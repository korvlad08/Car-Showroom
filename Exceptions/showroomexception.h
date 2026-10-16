#ifndef SHOWROOMEXCEPTION_H
#define SHOWROOMEXCEPTION_H

using namespace std;

class ShowroomException : public runtime_error
{
public:
    explicit ShowroomException(const srting& message);
};

class FileOpenException : public ShowroomException
{
private:
    string getPath();

public:
    explicit FileOpenException(const string& path);

    const string& getPath() const noexcept;
};

class InvalidFormatException : public ShowroomException
{
private:
    int line;
    string details;

public:
    InvalidFormatException(int line, const string& details);

    int getLine() const noexcept;
    const string getDetails() const noexcept;
};

class ValidationException : public ShowroomException
{
private:
    string field, details;

public:
    ValidationException(const string& field, const string& details);

    const string getField() const noexcept;
    const string getDetails() const noexcept;
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
