#ifndef SHOWROOMEXCEPTION_H
#define SHOWROOMEXCEPTION_H

#include <stdexcept>
#include <string>

class ShowroomException : public std::runtime_error
{
public:
    explicit ShowroomException(const std::string& message) : std::runtime_error(message){}
};

class FileOpenException : public ShowroomException
{
private:
    std::string path;

public:
    explicit FileOpenException(const std::string& path);

    const std::string& getPath() const noexcept;
};

class InvalidFormatException : public ShowroomException
{
private:
    int line;
    std::string details;

public:
    InvalidFormatException(int line, const std::string& details);

    int getLine() const noexcept;
    const std::string getDetails() const noexcept;
};

class ValidationException : public ShowroomException
{
private:
    std::string field, details;

public:
    ValidationException(const std::string& field, const std::string& details);

    const std::string getField() const noexcept;
    const std::string getDetails() const noexcept;
};

class CarNotFoundException : public ShowroomException
{
private:
    int id;

public:
    explicit CarNotFoundException(int id);

    int getId() const noexcept;
};

#endif // SHOWROOMEXCEPTION_H
