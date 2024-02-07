/*
 * Copyright 2016-2023 ClickHouse, Inc.
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 * http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */


/*
 * This file may have been modified by Bytedance Ltd. and/or its affiliates (“ Bytedance's Modifications”).
 * All Bytedance's Modifications are Copyright (2023) Bytedance Ltd. and/or its affiliates.
 */

#pragma once

#include <Columns/ColumnArray.h>
#include <Columns/ColumnConst.h>
#include <Columns/ColumnFixedString.h>
#include <Columns/ColumnNullable.h>
#include <Columns/ColumnString.h>
#include <DataTypes/DataTypeArray.h>
#include <DataTypes/DataTypeNullable.h>
#include <DataTypes/DataTypeString.h>
#include <Functions/FunctionHelpers.h>
#include <Functions/FunctionsConversion.h>
#include <Functions/IFunctionMySql.h>
#include <Functions/Regexps.h>
#include <IO/WriteHelpers.h>
#include <Interpreters/Context_fwd.h>
#include <Common/StringUtils/StringUtils.h>
#include <Common/assert_cast.h>
#include <Common/typeid_cast.h>

namespace DB
{

namespace ErrorCodes
{
    extern const int ILLEGAL_TYPE_OF_ARGUMENT;
    extern const int BAD_ARGUMENTS;
    extern const int ILLEGAL_COLUMN;
    extern const int NUMBER_OF_ARGUMENTS_DOESNT_MATCH;
}


/** Functions that split strings into an array of strings or vice versa.
  *
  * splitByChar(sep, s[, max_substrings])
  * splitByString(sep, s[, max_substrings])
  * splitByRegexp(regexp, s[, max_substrings])
  *
  * splitByWhitespace(s[, max_substrings])      - split the string by whitespace characters
  * splitByNonAlpha(s[, max_substrings])        - split the string by whitespace and punctuation characters
  *
  * extractAll(s, regexp)     - select from the string the subsequences corresponding to the regexp.
  * - first subpattern, if regexp has subpattern;
  * - zero subpattern (the match part, otherwise);
  * - otherwise, an empty array
  *
  * arrayStringConcat(arr)
  * arrayStringConcat(arr, delimiter)
  * - join an array of strings into one string via a separator.
  *
  * alphaTokens(s[, max_substrings])            - select from the string subsequence `[a-zA-Z]+`.
  *
  * URL functions are located separately.
  */


using Pos = const char *;


/// Substring generators. All of them have a common interface.

class SplitByAlphaImpl
{
private:
    Pos pos;
    Pos end;

public:
    /// Get the name of the function.
    static constexpr auto name = "alphaTokens";
    static String getName() { return name; }

    static bool isVariadic() { return true; }

    static size_t getNumberOfArguments() { return 0; }

    /// Check the type of the function's arguments.
    static void checkArguments(const DataTypes & arguments)
    {
        if (arguments.empty() || arguments.size() > 2)
            throw Exception(ErrorCodes::NUMBER_OF_ARGUMENTS_DOESNT_MATCH, "Function {} takes one or two arguments", getName());

        if (!isString(arguments[0]))
            throw Exception(ErrorCodes::ILLEGAL_TYPE_OF_ARGUMENT, "Illegal type {} of first argument of function {}. "
                "Must be String.", arguments[0]->getName(), getName());
    }

    /// Initialize by the function arguments.
    void init(const ColumnsWithTypeAndName & /*arguments*/) {}

    /// Called for each next string.
    void set(Pos pos_, Pos end_)
    {
        pos = pos_;
        end = end_;
    }

    /// Returns the position of the argument, that is the column of strings
    static size_t getStringsArgumentPosition()
    {
        return 0;
    }

    /// Returns the position of the possible max_substrings argument. std::nullopt means max_substrings argument is disabled in current function.
    static std::optional<size_t> getMaxSubstringsArgumentPosition()
    {
        return 1;
    }

    /// Get the next token, if any, or return false.
    bool get(Pos & token_begin, Pos & token_end)
    {
        /// Skip garbage
        while (pos < end && !isAlphaASCII(*pos))
            ++pos;

        if (pos == end)
            return false;

        token_begin = pos;

        while (pos < end && isAlphaASCII(*pos))
            ++pos;

        token_end = pos;

        return true;
    }
};

class SplitByNonAlphaImpl
{
private:
    Pos pos;
    Pos end;

public:
    /// Get the name of the function.
    static constexpr auto name = "splitByNonAlpha";
    static String getName() { return name; }

    static bool isVariadic() { return true; }
    static size_t getNumberOfArguments() { return 0; }

    /// Check the type of the function's arguments.
    static void checkArguments(const DataTypes & arguments)
    {
        if (arguments.empty() || arguments.size() > 2)
            throw Exception(ErrorCodes::NUMBER_OF_ARGUMENTS_DOESNT_MATCH, "Function {} takes one or two arguments", getName());

        if (!isString(arguments[0]))
            throw Exception(ErrorCodes::ILLEGAL_TYPE_OF_ARGUMENT, "Illegal type {} of first argument of function {}. "
                "Must be String.", arguments[0]->getName(), getName());
    }

    /// Initialize by the function arguments.
    void init(const ColumnsWithTypeAndName & /*arguments*/) {}

    /// Called for each next string.
    void set(Pos pos_, Pos end_)
    {
        pos = pos_;
        end = end_;
    }

    /// Returns the position of the argument, that is the column of strings
    static size_t getStringsArgumentPosition()
    {
        return 0;
    }

    /// Returns the position of the possible max_substrings argument. std::nullopt means max_substrings argument is disabled in current function.
    static std::optional<size_t> getMaxSubstringsArgumentPosition()
    {
        return 1;
    }

    /// Get the next token, if any, or return false.
    bool get(Pos & token_begin, Pos & token_end)
    {
        /// Skip garbage
        while (pos < end && (isWhitespaceASCII(*pos) || isPunctuationASCII(*pos)))
            ++pos;

        if (pos == end)
            return false;

        token_begin = pos;

        while (pos < end && !(isWhitespaceASCII(*pos) || isPunctuationASCII(*pos)))
            ++pos;

        token_end = pos;

        return true;
    }
};

class SplitByWhitespaceImpl
{
private:
    Pos pos;
    Pos end;

public:
    /// Get the name of the function.
    static constexpr auto name = "splitByWhitespace";
    static String getName() { return name; }

    static bool isVariadic() { return true; }
    static size_t getNumberOfArguments() { return 0; }

    /// Check the type of the function's arguments.
    static void checkArguments(const DataTypes & arguments)
    {
        if (arguments.empty() || arguments.size() > 2)
            throw Exception(ErrorCodes::NUMBER_OF_ARGUMENTS_DOESNT_MATCH, "Function {} takes one or two arguments", getName());

        if (!isString(arguments[0]))
            throw Exception(ErrorCodes::ILLEGAL_TYPE_OF_ARGUMENT, "Illegal type {} of first argument of function {}. "
                "Must be String.", arguments[0]->getName(), getName());
    }

    /// Initialize by the function arguments.
    void init(const ColumnsWithTypeAndName & /*arguments*/) {}

    /// Called for each next string.
    void set(Pos pos_, Pos end_)
    {
        pos = pos_;
        end = end_;
    }

    /// Returns the position of the argument, that is the column of strings
    static size_t getStringsArgumentPosition()
    {
        return 0;
    }

    /// Returns the position of the possible max_substrings argument. std::nullopt means max_substrings argument is disabled in current function.
    static std::optional<size_t> getMaxSubstringsArgumentPosition()
    {
        return 1;
    }

    /// Get the next token, if any, or return false.
    bool get(Pos & token_begin, Pos & token_end)
    {
        /// Skip garbage
        while (pos < end && isWhitespaceASCII(*pos))
            ++pos;

        if (pos == end)
            return false;

        token_begin = pos;

        while (pos < end && !isWhitespaceASCII(*pos))
            ++pos;

        token_end = pos;

        return true;
    }
};

class SplitByCharImpl
{
private:
    Pos pos;
    Pos end;
    char sep;

public:
    static constexpr auto name = "splitByChar";
    static String getName() { return name; }
    static bool isVariadic() { return true; }
    static size_t getNumberOfArguments() { return 0; }

    static void checkArguments(const DataTypes & arguments)
    {
        if (arguments.size() < 2 || arguments.size() > 3)
            throw Exception(
                ErrorCodes::NUMBER_OF_ARGUMENTS_DOESNT_MATCH,
                "Function '{}' needs at least 2 arguments, at most 3 arguments; passed {}.",
                name, arguments.size());

        if (!isString(arguments[0]))
            throw Exception(ErrorCodes::ILLEGAL_TYPE_OF_ARGUMENT, "Illegal type {} of first argument of function {}. "
                "Must be String.", arguments[0]->getName(), getName());

        if (!isString(arguments[1]))
            throw Exception(ErrorCodes::ILLEGAL_TYPE_OF_ARGUMENT, "Illegal type {} of second argument of function {}. "
                "Must be String.", arguments[1]->getName(), getName());
    }

    void init(const ColumnsWithTypeAndName & arguments)
    {
        const ColumnConst * col = checkAndGetColumnConstStringOrFixedString(arguments[0].column.get());

        if (!col)
            throw Exception(ErrorCodes::ILLEGAL_COLUMN, "Illegal column {} of first argument of function {}. "
                "Must be constant string.", arguments[0].column->getName(), getName());

        String sep_str = col->getValue<String>();

        if (sep_str.size() != 1)
            throw Exception(ErrorCodes::BAD_ARGUMENTS, "Illegal separator for function {}. Must be exactly one byte.", getName());

        sep = sep_str[0];
    }

    /// Returns the position of the argument, that is the column of strings
    static size_t getStringsArgumentPosition()
    {
        return 1;
    }

    /// Returns the position of the possible max_substrings argument. std::nullopt means max_substrings argument is disabled in current function.
    static std::optional<size_t> getMaxSubstringsArgumentPosition()
    {
        return 2;
    }

    void set(Pos pos_, Pos end_)
    {
        pos = pos_;
        end = end_;
    }

    bool get(Pos & token_begin, Pos & token_end)
    {
        if (!pos)
            return false;

        token_begin = pos;
        pos = reinterpret_cast<Pos>(memchr(pos, sep, end - pos));

        if (pos)
        {
            token_end = pos;
            ++pos;
        }
        else
            token_end = end;

        return true;
    }
};


template <typename NameAndIndex>
class SplitByStringImpl
{
private:
    Pos pos;
    Pos end;

    String sep;

public:
    static constexpr auto name = NameAndIndex::name;
    static String getName() { return name; }
    static bool isVariadic() { return true; }
    static size_t getNumberOfArguments() { return 0; }

    static void checkArguments(const DataTypes & arguments)
    {
        SplitByCharImpl::checkArguments(arguments);
    }

    void init(const ColumnsWithTypeAndName & arguments)
    {
        size_t idx = NameAndIndex::regex_index;
        const ColumnConst * col = checkAndGetColumnConstStringOrFixedString(arguments[idx].column.get());

        if (!col)
            throw Exception(ErrorCodes::ILLEGAL_COLUMN, "Illegal column {} of first argument of function {}. "
                "Must be constant string.", arguments[idx].column->getName(), getName());

        sep = col->getValue<String>();
    }

    /// Returns the position of the argument that is the column of strings
    static size_t getStringsArgumentPosition()
    {
        return NameAndIndex::data_index;
    }

    /// Returns the position of the possible max_substrings argument. std::nullopt means max_substrings argument is disabled in current function.
    static std::optional<size_t> getMaxSubstringsArgumentPosition()
    {
        return 2;
    }

    /// Called for each next string.
    void set(Pos pos_, Pos end_)
    {
        pos = pos_;
        end = end_;
    }

    /// Get the next token, if any, or return false.
    bool get(Pos & token_begin, Pos & token_end)
    {
        if (sep.empty())
        {
            if (pos == end)
                return false;

            token_begin = pos;
            pos += 1;
            token_end = pos;
        }
        else
        {
            if (!pos)
                return false;

            token_begin = pos;

            pos = reinterpret_cast<Pos>(memmem(pos, end - pos, sep.data(), sep.size()));

            if (pos)
            {
                token_end = pos;
                pos += sep.size();
            }
            else
                token_end = end;
        }

        return true;
    }
};

struct SplitStringName
{
    static constexpr auto name = "splitByString";
    static constexpr size_t data_index = 1;
    static constexpr size_t regex_index = 0;
};

struct HiveSplitNameAndIndex
{
    static constexpr auto name = "split";
    static constexpr size_t data_index = 0;
    static constexpr size_t regex_index = 1;
};

struct SplitByRegexNameAndIndex
{
    static constexpr auto name = "splitByRegexp";
    static constexpr size_t data_index = 1;
    static constexpr size_t regex_index = 0;
};

template <typename NameAndIndex>
class SplitByRegexpImpl
{
private:
    Regexps::RegexpPtr re;
    OptimizedRegularExpression::MatchVec matches;

    Pos pos;
    Pos end;

public:
    static constexpr auto name = NameAndIndex::name;
    static String getName() { return name; }

    static bool isVariadic() { return true; }
    static size_t getNumberOfArguments() { return 0; }

    /// Check the type of function arguments.
    static void checkArguments(const DataTypes & arguments)
    {
        SplitByStringImpl<NameAndIndex>::checkArguments(arguments);
    }

    /// Initialize by the function arguments.
    void init(const ColumnsWithTypeAndName & arguments)
    {
        size_t regex_index = NameAndIndex::regex_index;
        const ColumnConst * col = checkAndGetColumnConstStringOrFixedString(arguments[regex_index].column.get());

        if (!col)
            throw Exception(ErrorCodes::ILLEGAL_COLUMN, "Illegal column {} of first argument of function {}. "
                            "Must be constant string.", arguments[regex_index].column->getName(), getName());

        if (!col->getValue<String>().empty())
            re = std::make_shared<OptimizedRegularExpression>(Regexps::createRegexp<false, false, false>(col->getValue<String>()));
    }

    /// Returns the position of the argument that is the column of strings
    static size_t getStringsArgumentPosition()
    {
        return NameAndIndex::data_index;
    }

    /// Returns the position of the possible max_substrings argument. std::nullopt means max_substrings argument is disabled in current function.
    static std::optional<size_t> getMaxSubstringsArgumentPosition()
    {
        return 2;
    }

    /// Called for each next string.
    void set(Pos pos_, Pos end_)
    {
        pos = pos_;
        end = end_;
    }

    /// Get the next token, if any, or return false.
    bool get(Pos & token_begin, Pos & token_end)
    {
        if (!re)
        {
            if (pos == end)
                return false;

            token_begin = pos;
            pos += 1;
            token_end = pos;
        }
        else
        {
            if (!pos || pos > end)
                return false;

            token_begin = pos;

            if (!re->match(pos, end - pos, matches) || !matches[0].length)
            {
                token_end = end;
                pos = end + 1;
            }
            else
            {
                token_end = pos + matches[0].offset;
                pos = token_end + matches[0].length;
            }
        }

        return true;
    }
};

class ExtractAllImpl
{
private:
    Regexps::RegexpPtr re;
    OptimizedRegularExpression::MatchVec matches;
    size_t capture;

    Pos pos;
    Pos end;
public:
    static constexpr auto name = "extractAll";
    static String getName() { return name; }
    static bool isVariadic() { return false; }
    static size_t getNumberOfArguments() { return 2; }

    /// Check the type of function arguments.
    static void checkArguments(const DataTypes & arguments)
    {
        SplitByStringImpl<SplitStringName>::checkArguments(arguments);
    }

    /// Initialize by the function arguments.
    void init(const ColumnsWithTypeAndName & arguments)
    {
        const ColumnConst * col = checkAndGetColumnConstStringOrFixedString(arguments[1].column.get());

        if (!col)
            throw Exception(ErrorCodes::ILLEGAL_COLUMN, "Illegal column {} of first argument of function {}. "
                "Must be constant string.", arguments[1].column->getName(), getName());

        re = std::make_shared<OptimizedRegularExpression>(Regexps::createRegexp<false, false, false>(col->getValue<String>()));
        capture = re->getNumberOfSubpatterns() > 0 ? 1 : 0;

        matches.resize(capture + 1);
    }

    /// Returns the position of the argument that is the column of strings
    static size_t getStringsArgumentPosition()
    {
        return 0;
    }

    /// Returns the position of the possible max_substrings argument. std::nullopt means max_substrings argument is disabled in current function.
    static std::optional<size_t> getMaxSubstringsArgumentPosition()
    {
        return std::nullopt;
    }

    /// Called for each next string.
    void set(Pos pos_, Pos end_)
    {
        pos = pos_;
        end = end_;
    }

    /// Get the next token, if any, or return false.
    bool get(Pos & token_begin, Pos & token_end)
    {
        if (!pos || pos > end)
            return false;

        if (!re->match(pos, end - pos, matches) || !matches[0].length)
            return false;

        if (matches[capture].offset == std::string::npos)
        {
            /// Empty match.
            token_begin = pos;
            token_end = pos;
        }
        else
        {
            token_begin = pos + matches[capture].offset;
            token_end = token_begin + matches[capture].length;
        }

        pos += matches[0].offset + matches[0].length;

        return true;
    }
};

/// A function that takes a string, and returns an array of substrings created by some generator.
template <typename Generator>
class FunctionTokens : public IFunction
{
public:
    static constexpr auto name = Generator::name;
    static FunctionPtr create(ContextPtr context)
    {
        if (context && context->getSettingsRef().enable_implicit_arg_type_convert)
            return std::make_shared<IFunctionMySql>(std::make_unique<FunctionTokens>());
        return std::make_shared<FunctionTokens>();
    }

    ArgType getArgumentsType() const override { return ArgType::STRINGS; }

    String getName() const override
    {
        return name;
    }

    bool isSuitableForShortCircuitArgumentsExecution(const DataTypesWithConstInfo & /*arguments*/) const override { return true; }

    bool isVariadic() const override { return Generator::isVariadic(); }

    size_t getNumberOfArguments() const override { return Generator::getNumberOfArguments(); }

    DataTypePtr getReturnTypeImpl(const DataTypes & arguments) const override
    {
        Generator::checkArguments(arguments);

        const auto max_substrings_pos = Generator::getMaxSubstringsArgumentPosition();
        if (max_substrings_pos && *max_substrings_pos < arguments.size() && !isNativeInteger(arguments[*max_substrings_pos]))
            throw Exception(
                ErrorCodes::ILLEGAL_TYPE_OF_ARGUMENT,
                "{}-th argument for function '{}' must be integer, got '{}' instead",
                *max_substrings_pos + 1,
                getName(),
                arguments[*max_substrings_pos]->getName());

        return std::make_shared<DataTypeArray>(std::make_shared<DataTypeString>());
    }

    ColumnPtr executeImpl(const ColumnsWithTypeAndName & arguments, const DataTypePtr & result_type, size_t /*input_rows_count*/) const override
    {
        Generator generator;
        generator.init(arguments);
        const auto & array_argument = arguments[generator.getStringsArgumentPosition()];

        /// Whether we need to limit max tokens returned by Generator::get
        /// If max_substrings is std::nullopt, no limit is applied.
        auto max_substrings = getMaxSubstrings(arguments);

        const ColumnString * col_str = checkAndGetColumn<ColumnString>(array_argument.column.get());
        const ColumnConst * col_const_str =
                checkAndGetColumnConstStringOrFixedString(array_argument.column.get());

        auto col_res = ColumnArray::create(ColumnString::create());
        ColumnString & res_strings = typeid_cast<ColumnString &>(col_res->getData());
        ColumnArray::Offsets & res_offsets = col_res->getOffsets();
        ColumnString::Chars & res_strings_chars = res_strings.getChars();
        ColumnString::Offsets & res_strings_offsets = res_strings.getOffsets();

        if (col_str)
        {
            const ColumnString::Chars & src_chars = col_str->getChars();
            const ColumnString::Offsets & src_offsets = col_str->getOffsets();

            res_offsets.reserve(src_offsets.size());
            res_strings_offsets.reserve(src_offsets.size() * 5);    /// Constant 5 - at random.
            res_strings_chars.reserve(src_chars.size());

            Pos token_begin = nullptr;
            Pos token_end = nullptr;

            size_t size = src_offsets.size();
            ColumnString::Offset current_src_offset = 0;
            ColumnArray::Offset current_dst_offset = 0;
            ColumnString::Offset current_dst_strings_offset = 0;
            for (size_t i = 0; i < size; ++i)
            {
                Pos pos = reinterpret_cast<Pos>(&src_chars[current_src_offset]);
                current_src_offset = src_offsets[i];
                Pos end = reinterpret_cast<Pos>(&src_chars[current_src_offset]) - 1;

                generator.set(pos, end);
                size_t j = 0;
                while (generator.get(token_begin, token_end) && !(max_substrings && j >= *max_substrings))
                {
                    size_t token_size = token_end - token_begin;

                    res_strings_chars.resize(res_strings_chars.size() + token_size + 1);
                    memcpySmallAllowReadWriteOverflow15(&res_strings_chars[current_dst_strings_offset], token_begin, token_size);
                    res_strings_chars[current_dst_strings_offset + token_size] = 0;

                    current_dst_strings_offset += token_size + 1;
                    res_strings_offsets.push_back(current_dst_strings_offset);
                    ++j;
                }

                current_dst_offset += j;
                res_offsets.push_back(current_dst_offset);
            }

            return col_res;
        }
        else if (col_const_str)
        {
            String src = col_const_str->getValue<String>();
            Array dst;

            generator.set(src.data(), src.data() + src.size());
            Pos token_begin = nullptr;
            Pos token_end = nullptr;

            while (generator.get(token_begin, token_end) && !(max_substrings && dst.size() >= *max_substrings))
                dst.push_back(String(token_begin, token_end - token_begin));

            return result_type->createColumnConst(col_const_str->size(), dst);
        }
        else
            throw Exception(ErrorCodes::ILLEGAL_COLUMN, "Illegal columns {}, {} of arguments of function {}",
                    array_argument.column->getName(), array_argument.column->getName(), getName());
    }

private:
    template <typename DataType>
    std::optional<Int64> getMaxSubstringsImpl(const ColumnWithTypeAndName & argument) const
    {
        const auto * col = checkAndGetColumnConst<ColumnVector<DataType>>(argument.column.get());
        if (!col)
            return {};

        auto value = col->template getValue<DataType>();
        return static_cast<Int64>(value);
    }

    std::optional<size_t> getMaxSubstrings(const ColumnsWithTypeAndName & arguments) const
    {
        const auto pos = Generator::getMaxSubstringsArgumentPosition();
        if (!pos)
            return std::nullopt;

        if (*pos >= arguments.size())
            return std::nullopt;

        std::optional<Int64> max_substrings;
        if (!((max_substrings = getMaxSubstringsImpl<UInt8>(arguments[*pos])) || (max_substrings = getMaxSubstringsImpl<Int8>(arguments[*pos]))
              || (max_substrings = getMaxSubstringsImpl<UInt16>(arguments[*pos])) || (max_substrings = getMaxSubstringsImpl<Int16>(arguments[*pos]))
              || (max_substrings = getMaxSubstringsImpl<UInt32>(arguments[*pos])) || (max_substrings = getMaxSubstringsImpl<Int32>(arguments[*pos]))
              || (max_substrings = getMaxSubstringsImpl<UInt64>(arguments[*pos])) || (max_substrings = getMaxSubstringsImpl<Int64>(arguments[*pos]))))
            throw Exception(
                ErrorCodes::ILLEGAL_COLUMN,
                "Illegal column {}, which is {}-th argument of function {}",
                arguments[*pos].column->getName(),
                *pos + 1,
                getName());

        /// If max_substrings is negative or zero, tokenize will be applied as many times as possible, which is equivalent to
        /// no max_substrings argument in function
        if (max_substrings && *max_substrings <= 0)
            return std::nullopt;

        return *max_substrings;
    }
};


/// Joins an array of type serializable to string into one string via a separator.
class FunctionArrayStringConcat : public IFunction
{
private:
    static void executeInternal(
        const ColumnString::Chars & src_chars,
        const ColumnString::Offsets & src_string_offsets,
        const ColumnArray::Offsets & src_array_offsets,
        const char * delimiter,
        const size_t delimiter_size,
        ColumnString::Chars & dst_chars,
        ColumnString::Offsets & dst_string_offsets,
        const char8_t * null_map)
    {
        size_t size = src_array_offsets.size();

        if (!size)
            return;

        /// With a small margin - as if the separator goes after the last string of the array.
        dst_chars.resize(
            src_chars.size()
            + delimiter_size * src_string_offsets.size()    /// Separators after each string...
            + src_array_offsets.size()                      /// Zero byte after each joined string
            - src_string_offsets.size());                   /// The former zero byte after each string of the array

        /// There will be as many strings as there were arrays.
        dst_string_offsets.resize(src_array_offsets.size());

        ColumnArray::Offset current_src_array_offset = 0;

        ColumnString::Offset current_dst_string_offset = 0;

        /// Loop through the array of strings.
        for (size_t i = 0; i < size; ++i)
        {
            bool first_non_null = true;
            /// Loop through the rows within the array. /// NOTE You can do everything in one copy, if the separator has a size of 1.
            for (auto next_src_array_offset = src_array_offsets[i]; current_src_array_offset < next_src_array_offset; ++current_src_array_offset)
            {
                if (unlikely(null_map && null_map[current_src_array_offset]))
                    continue;

                if (!first_non_null)
                {
                    memcpy(&dst_chars[current_dst_string_offset], delimiter, delimiter_size);
                    current_dst_string_offset += delimiter_size;
                }
                first_non_null = false;

                const auto current_src_string_offset = current_src_array_offset ? src_string_offsets[current_src_array_offset - 1] : 0;
                size_t bytes_to_copy = src_string_offsets[current_src_array_offset] - current_src_string_offset - 1;

                memcpySmallAllowReadWriteOverflow15(
                    &dst_chars[current_dst_string_offset], &src_chars[current_src_string_offset], bytes_to_copy);

                current_dst_string_offset += bytes_to_copy;
            }

            dst_chars[current_dst_string_offset] = 0;
            ++current_dst_string_offset;

            dst_string_offsets[i] = current_dst_string_offset;
        }

        dst_chars.resize(dst_string_offsets.back());
    }

    static void executeInternal(
        const ColumnString & col_string,
        const ColumnArray & col_arr,
        const String & delimiter,
        ColumnString & col_res,
        const char8_t * null_map = nullptr)
    {
        executeInternal(
            col_string.getChars(),
            col_string.getOffsets(),
            col_arr.getOffsets(),
            delimiter.data(),
            delimiter.size(),
            col_res.getChars(),
            col_res.getOffsets(),
            null_map);
    }

    static ColumnPtr serializeNestedColumn(const ColumnArray & col_arr, const DataTypePtr & nested_type)
    {
        if (isString(nested_type))
        {
            return col_arr.getDataPtr();
        }
        else if (const ColumnNullable * col_nullable = checkAndGetColumn<ColumnNullable>(col_arr.getData());
                 col_nullable && isString(col_nullable->getNestedColumn().getDataType()))
        {
            return col_nullable->getNestedColumnPtr();
        }
        else
        {
            ColumnsWithTypeAndName cols;
            cols.emplace_back(col_arr.getDataPtr(), nested_type, "tmp");
            return ConvertImplGenericToString<ColumnString>::execute(cols, std::make_shared<DataTypeString>(), col_arr.size());
        }
    }

public:
    static constexpr auto name = "arrayStringConcat";
    static FunctionPtr create(ContextPtr) { return std::make_shared<FunctionArrayStringConcat>(); }

    String getName() const override
    {
        return name;
    }

    bool isVariadic() const override { return true; }
    bool isSuitableForShortCircuitArgumentsExecution(const DataTypesWithConstInfo & /*arguments*/) const override { return true; }
    size_t getNumberOfArguments() const override { return 0; }

    DataTypePtr getReturnTypeImpl(const DataTypes & arguments) const override;

    ColumnPtr executeImpl(const ColumnsWithTypeAndName & arguments, const DataTypePtr & result_type, size_t /*input_rows_count*/) const override
    {
        String delimiter;
        if (arguments.size() == 2)
        {
            const ColumnConst * col_delim = checkAndGetColumnConstStringOrFixedString(arguments[1].column.get());
            if (!col_delim)
                throw Exception(ErrorCodes::ILLEGAL_COLUMN, "Second argument for function {} must be constant string.", getName());

            delimiter = col_delim->getValue<String>();
        }

        const auto & nested_type = assert_cast<const DataTypeArray &>(*arguments[0].type).getNestedType();
        if (const ColumnConst * col_const_arr = checkAndGetColumnConst<ColumnArray>(arguments[0].column.get());
            col_const_arr && isString(nested_type))
        {
            Array src_arr = col_const_arr->getValue<Array>();
            String dst_str;
            bool first_non_null = true;
            for (size_t i = 0, size = src_arr.size(); i < size; ++i)
            {
                if (src_arr[i].isNull())
                    continue;
                if (!first_non_null)
                    dst_str += delimiter;
                first_non_null = false;
                dst_str += src_arr[i].get<const String &>();
            }

            return result_type->createColumnConst(col_const_arr->size(), dst_str);
        }

        ColumnPtr src_column = arguments[0].column->convertToFullColumnIfConst();
        const ColumnArray & col_arr = assert_cast<const ColumnArray &>(*src_column.get());

        ColumnPtr str_subcolumn = serializeNestedColumn(col_arr, nested_type);
        const ColumnString & col_string = assert_cast<const ColumnString &>(*str_subcolumn.get());

        auto col_res = ColumnString::create();
        if (const ColumnNullable * col_nullable = checkAndGetColumn<ColumnNullable>(col_arr.getData()))
            executeInternal(col_string, col_arr, delimiter, *col_res, col_nullable->getNullMapData().data());
        else
            executeInternal(col_string, col_arr, delimiter, *col_res);
        return col_res;
    }
};


using FunctionSplitByAlpha = FunctionTokens<SplitByAlphaImpl>;
using FunctionSplitByNonAlpha = FunctionTokens<SplitByNonAlphaImpl>;
using FunctionSplitByWhitespace = FunctionTokens<SplitByWhitespaceImpl>;
using FunctionSplitByChar = FunctionTokens<SplitByCharImpl>;
using FunctionSplitByString = FunctionTokens<SplitByStringImpl<SplitStringName>>;
using FunctionHiveSplit = FunctionTokens<SplitByStringImpl<HiveSplitNameAndIndex>>;
using FunctionSplitByRegexp = FunctionTokens<SplitByRegexpImpl<SplitByRegexNameAndIndex>>;
using FunctionExtractAll = FunctionTokens<ExtractAllImpl>;

}
