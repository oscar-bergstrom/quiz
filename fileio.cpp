#include "fileio.h"
#include <QFile>
#include <QDir>
#include <QTextStream>
#include <QDebug>
#include <QString>
#include <QFileInfo>

const QRegularExpression FileIO::URI("^(file:\\/{3})|(qrc:\\/{2})|(http:\\/{2})");

FileIO::FileIO(QObject *parent) :
    QObject(parent)
{

}

QString FileIO::read()
{
    if (mSource.isEmpty()){
        emit error("source is empty");
        return QString();
    }

#ifdef Q_OS_WINDOWS
   mSource = stripURI(mSource);
#elif defined (Q_OS_LINUX)
    mSource = "/" + stripURI(mSource);
#endif


    QFile file(mSource);
    QString fileContent;
    if ( file.open(QIODevice::ReadOnly) ) {
        QString line;
        QTextStream t( &file );
        t.setCodec("UTF-8");
        do {
            line = t.readLine();
            fileContent += line;
         } while (!line.isNull());

        file.close();
    } else {
        emit error("Unable to open the file: " + file.errorString());
        return QString();
    }
    return fileContent;
}

bool FileIO::write(const QString& data)
{
    if (mSource.isEmpty())
        return false;

    QFile file(mSource);
    if (!file.open(QFile::WriteOnly | QFile::Truncate))
        return false;

    QTextStream out(&file);
    out << data;

    file.close();

    return true;
}

QString FileIO::stripURI(const QString &url) const
{
    QString s(url);
    return s.replace("file:///", "");
}

QString FileIO::path() const
{
    return mPath;
}

void FileIO::setSource(const QString &source)
{

    if (source != mSource) {

        QFileInfo f(source);
        mPath = f.dir().path();
        emit pathChanged(mPath);

        mSource = source;
        emit sourceChanged(mSource);


    }
}
