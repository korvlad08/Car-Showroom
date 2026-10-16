#include "showroomexception.h"

using namespace std;

ShowroomException::ShowroomException(const srting& message)
{
    runtime_error(message);
}

FileOpenException::FileOpenException(const string& path)
{
    ShowroomException("Not opened file: " + path);
    this->path=path;
}

FileOpenException::getPath()
{
    return path;
}

InvalidFormatException::InvalidFormatException(int line, const string& details)
{
    ShowroomException("Error format in line" + to_string(line) + ": " + details);

    this->line=line;
    this->details=details;
}

InvalidFormatException::getDetails()
{
    return details;
}

InvalidFormatException::getLine()
{
    return line;
}

ValidationException::ValidationException(const string& field, const string& details)
{
    ShowroomException("Error field " + field + ": " + details);

    this->field=field;
    this->details=details;
}

ValidationException::getDetails()
{
    return details;
}

ValidationException::getField()
{
    return field;
}

CarNotFoundException::CarNotFoundException(int id)
{
    ShowroomException("Not found car with id: " + to_string(id));

    this->id=id;
}

CarNotFoundException::getId()
{
    return id;
}