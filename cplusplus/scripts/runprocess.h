/**************************************************************************
 **                                                                      **
 ** Copyright (C) 2018 Lukas Spies                                       **
 ** Contact: http://photoqt.org                                          **
 **                                                                      **
 ** This file is part of PhotoQt.                                        **
 **                                                                      **
 ** PhotoQt is free software: you can redistribute it and/or modify      **
 ** it under the terms of the GNU General Public License as published by **
 ** the Free Software Foundation, either version 2 of the License, or    **
 ** (at your option) any later version.                                  **
 **                                                                      **
 ** PhotoQt is distributed in the hope that it will be useful,           **
 ** but WITHOUT ANY WARRANTY; without even the implied warranty of       **
 ** MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the        **
 ** GNU General Public License for more details.                         **
 **                                                                      **
 ** You should have received a copy of the GNU General Public License    **
 ** along with PhotoQt. If not, see <http://www.gnu.org/licenses/>.      **
 **                                                                      **
 **************************************************************************/

#ifndef RUNPROCESS_H
#define RUNPROCESS_H

#include <QProcess>
#include <QApplication>
#include <thread>

// This is a convenience class to start a process and receive the standard output with ease
class RunProcess : public QObject {

    Q_OBJECT

public:
    explicit RunProcess() {
        proc = new QProcess;
        gotOutput = false;
        error = false;
        connect(proc, &QProcess::readyRead, this, &RunProcess::read);
        connect(proc, static_cast<void (QProcess::*)(QProcess::ProcessError)>(&QProcess::error), this, &RunProcess::readError);
    }
    ~RunProcess() { while(proc->waitForFinished()) {} delete proc; }
    // START PROCESS
    void start(QString exec) {
        gotOutput = false;
        error = false;
        proc->start(exec);
    }

    // GET INFO
    QString getOutput() { return output; }
    bool gotError() { return error; }
    int getErrorCode() { return errorCode; }

    // WAIT FUNCTION
    bool waitForOutput() {
        std::this_thread::sleep_for(std::chrono::milliseconds(100));
        QApplication::processEvents();
        return !gotOutput;
    }

private:
    QProcess *proc;
    QString output;
    bool gotOutput;
    bool error;
    int errorCode;

private slots:
    void read() {
        output = proc->readAll();
        gotOutput = true;
    }
    void readError(QProcess::ProcessError e) {
        output = "";
        error = true;
        gotOutput = true;
        errorCode = e;
    }

};


#endif // RUNPROCESS_H
