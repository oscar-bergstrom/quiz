#ifndef FILEIO_H
#define FILEIO_H

#include <QObject>
#include <QRegularExpression>


class FileIO : public QObject
{
    Q_OBJECT

public:
    Q_PROPERTY(QString source
               READ source
               WRITE setSource
               NOTIFY sourceChanged)

    Q_PROPERTY(QString path
               READ path
               NOTIFY pathChanged)

    explicit FileIO(QObject *parent = nullptr);

    Q_INVOKABLE QString read();
    Q_INVOKABLE bool write(const QString& data);

    Q_INVOKABLE QString stripURI(const QString &url) const;
    QString source() { return mSource; }
    QString path() const;

public slots:
    void setSource(const QString& source);

signals:
    void sourceChanged(const QString& source);
    void pathChanged(const QString & path);
    void error(const QString& msg);

private:
    QString mSource;
    QString mPath;
    static const QRegularExpression URI;
};

#endif // FILEIO_H
