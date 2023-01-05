#pragma once

#include <Core/ColumnWithTypeAndName.h>


namespace DB
{

/// getLeastSupertype + related column changes
ColumnWithTypeAndName getLeastSuperColumn(const std::vector<const ColumnWithTypeAndName *> & columns, bool allow_extended_conversion = false);

}
