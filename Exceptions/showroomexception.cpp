#include "showroomexception.h"

FileOpenException::FileOpenException(const std::string& path) : ShowroomException("Not opened file: " + path)
{
    this->path=path;
}

const std::string& FileOpenException::getPath() const noexcept
{
    return path;
}

InvalidFormatException::InvalidFormatException(int line, const std::string& details)
    : ShowroomException("Error format in line" + std::to_string(line) + ": " + details)
{


    this->line=line;
    this->details=details;
}

const std::string InvalidFormatException::getDetails() const noexcept
{
    return details;
}

int InvalidFormatException::getLine() const noexcept
{
    return line;
}

ValidationException::ValidationException(const std::string& field, const std::string& details)
    : ShowroomException("Error field " + field + ": " + details)
{
    this->field=field;
    this->details=details;
}

const std::string ValidationException::getDetails() const noexcept
{
    return details;
}

const std::string ValidationException::getField() const noexcept
{
    return field;
}

CarNotFoundException::CarNotFoundException(int id)
    : ShowroomException("Not found car with id: " + std::to_string(id))
{
    this->id=id;
}

int CarNotFoundException::getId() const noexcept
{
    return id;
}