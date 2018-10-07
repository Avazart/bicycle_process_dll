#include "bicycle_process.h"

#include <Bicycle/Win/Process/Process.h>
#include <Bicycle/Win/Experimental/Thread.h>
#include <Bicycle/Win/Experimental/Encoding.h>
//---------------------------------------------------------------------------------
struct ProcessData
{
	Bicycle::Process process;
	std::string lastError;
  ulong lastErrorCode = 0;
};
//---------------------------------------------------------------------------------
template <typename CharT>
inline std::basic_string<CharT> make_std_string(const CharT * c_string)
{
  return c_string ? c_string: std::basic_string<CharT>();
}
//---------------------------------------------------------------------------------
inline ProcessData* castToData(bi_process_handle handle)
{
	return reinterpret_cast<ProcessData*>(handle);
}
//=====================================================================================
bool bi_process_has_error(bi_process_handle handle)
{
  return castToData(handle)->lastErrorCode!=0;
}

void bi_process_clear_last_error(bi_process_handle handle)
{
  castToData(handle)->lastErrorCode = 0;
  castToData(handle)->lastError.clear();
}

const char *bi_process_last_error(bi_process_handle handle)
{
  return castToData(handle)->lastError.c_str();
}

ulong bi_process_last_error_code(bi_process_handle handle)
{
  return castToData(handle)->lastErrorCode;
}


bi_process_handle bi_process_create()
{
	return new ProcessData;
}

void bi_process_destroy(bi_process_handle handle)
{
  delete castToData(handle);
}

void bi_process_set_app_name(bi_process_handle handle, const wchar_t *app_name)
{
  castToData(handle)->process.setAppName(make_std_string(app_name));
}

void bi_process_set_cmd_line(bi_process_handle handle, const wchar_t *cmd_line)
{
  castToData(handle)->process.setCmdLine(make_std_string(cmd_line));
}

void bi_process_set_current_dir(bi_process_handle handle, const wchar_t *current_dir)
{
  castToData(handle)->process.setCurrentDir(make_std_string(current_dir));
}

void bi_process_use_pipes(bi_process_handle handle, bool use_pipes)
{
  castToData(handle)->process.usePipes(use_pipes);
}

void bi_process_set_startup_info_flags(bi_process_handle handle, ulong startup_info_flags)
{
  castToData(handle)->process.setStartupInfoFlags(startup_info_flags);
}

HANDLE bi_process_process_handle(bi_process_handle handle)
{
  return  castToData(handle)->process.processHandle();
}

HANDLE bi_process_thread_handle(bi_process_handle handle)
{
  return  castToData(handle)->process.threadHandle();
}

ulong bi_process_process_id(bi_process_handle handle)
{
  return  castToData(handle)->process.processId();
}

ulong bi_process_thread_id(bi_process_handle handle)
{
  return  castToData(handle)->process.threadId();
}

void bi_process_cancel(bi_process_handle handle)
{
  return  castToData(handle)->process.cancel();
}

bool bi_process_start2(bi_process_handle handle, const wchar_t *app_name, const wchar_t *cmd_line)
{
	try
  {
    castToData(handle)->process.start(make_std_string(app_name),make_std_string(cmd_line));
		return true;
	}
  catch(const Bicycle::SystemException& e)
	{
    castToData(handle)->lastError= e.message();
    castToData(handle)->lastErrorCode= e.code();
		return false;
	}
}

bool bi_process_start(bi_process_handle handle)
{
  try
  {
    castToData(handle)->process.start();
    return true;
  }
  catch(const Bicycle::SystemException& e)
  {
    castToData(handle)->lastError= e.message();
    castToData(handle)->lastErrorCode= e.code();
    return false;
  }
}

void bi_process_terminate(bi_process_handle handle, unsigned exit_code)
{
	try
	{
    castToData(handle)->process.terminate(exit_code);
	}
  catch(const Bicycle::SystemException& e)
  {
    castToData(handle)->lastError= e.message();
    castToData(handle)->lastErrorCode= e.code();
  }
}

void bi_process_close_windows(bi_process_handle handle)
{
	try
	{
    castToData(handle)->process.closeWindows();
	}
  catch(const Bicycle::SystemException& e)
  {
    castToData(handle)->lastError= e.message();
    castToData(handle)->lastErrorCode= e.code();
  }
}

void bi_process_detach(bi_process_handle handle)
{
	try
	{
    castToData(handle)->process.detach();
	}
  catch(const Bicycle::SystemException& e)
  {
    castToData(handle)->lastError= e.message();
    castToData(handle)->lastErrorCode= e.code();
  }
}


void bi_process_set_inherit_handle(bi_process_handle handle, bool inherit_handle)
{
	try
	{
    castToData(handle)->process.setInheritHandle(inherit_handle);
	}
  catch(const Bicycle::SystemException& e)
	{
    castToData(handle)->lastError= e.message();
    castToData(handle)->lastErrorCode= e.code();
	}
}

void bi_process_set_security_inherit_handle(bi_process_handle handle, bool inherit_handle)
{
	try
	{
    castToData(handle)->process.setSecurityInheritHandle(inherit_handle);
	}
  catch(const Bicycle::SystemException& e)
  {
    castToData(handle)->lastError= e.message();
    castToData(handle)->lastErrorCode= e.code();
  }
}

void bi_process_set_show_window(bi_process_handle handle,unsigned short show_window)
{
	try
	{
    castToData(handle)->process.setShowWindow(show_window);
	}
  catch(const Bicycle::SystemException& e)
  {
    castToData(handle)->lastError= e.message();
    castToData(handle)->lastErrorCode= e.code();
  }
}

ulong bi_process_pipe_stdout_read(bi_process_handle handle, char *data, ulong size)
{
	try
	{
    return castToData(handle)->process.stdOut().read(data,size);
	}
  catch(const Bicycle::SystemException& e)
  {
    castToData(handle)->lastError= e.message();
    castToData(handle)->lastErrorCode= e.code();
    return 0;
  }
}

ulong bi_process_pipe_stdin_write(bi_process_handle handle, const char *data, ulong size)
{
	try
	{
    return castToData(handle)->process.stdIn().write(data,size);
	}
  catch(const Bicycle::SystemException& e)
  {
    castToData(handle)->lastError= e.message();
    castToData(handle)->lastErrorCode= e.code();
    return 0;
  }
}

void bi_process_pipe_stdout_set_timeout(bi_process_handle handle, ulong msecs)
{
  castToData(handle)->process.stdOut().setTimeOut(msecs);
}

void bi_process_pipe_stdout_set_buffer_size(bi_process_handle handle, ulong size)
{
  castToData(handle)->process.stdOut().setBufferSize(size);
}
//=======================================================================================
class WorkThread:public Bicycle::Thread
{
  public:
     WorkThread(const std::wstring& app_name,
                const std::wstring& cmd_line,
                const std::wstring& current_dir,
                HWND mainWindowHandle,
                UINT readDataMessage,
                UINT finishedMessage,
                bool decodeOEM);

     virtual ~WorkThread()override= default;

     ulong exitCode();

     const std::string & lastError() const;
     ulong lastErrorCode() const;
     bool hasError()const;

     void cahcel();

  protected:
     virtual void run() override;

  private:
     Bicycle::Process process_;
     Bicycle::AtomicCounter lastErrorCode_;
     mutable std::string lastError_;

     HWND mainWindowHandle_;
     UINT readDataMessage_;
     UINT finishedMessage_;
     bool decodeOEM_;
};
//--------------------------------------------------------------------------------------
WorkThread::WorkThread(const std::wstring &app_name,
                       const std::wstring &cmd_line,
                       const std::wstring &current_dir,
                       HWND mainWindowHandle,
                       UINT readDataMessage,
                       UINT finishedMessage,
                       bool decodeOEM)
  :Bicycle::Thread(),
   process_(app_name,cmd_line),
   lastErrorCode_(0),

   mainWindowHandle_(mainWindowHandle),
   readDataMessage_(readDataMessage),
   finishedMessage_(finishedMessage),
   decodeOEM_(decodeOEM)
{
  process_.setInheritHandle(true);
  process_.setSecurityInheritHandle(true);
  process_.usePipes(true);
  process_.setShowWindow(SW_HIDE);
  process_.setCurrentDir(current_dir);
}

ulong WorkThread::exitCode()
{
  try
  {
    return process_.exitCode();
  }
  catch(const Bicycle::SystemException& e)
  {
    lastErrorCode_ = static_cast<LONG>(e.code());
    return 0;
  }
}

const std::string& WorkThread::lastError() const
{
  lastError_ =  Bicycle::formatMessage(static_cast<ulong>(lastErrorCode_.load()));
  return lastError_;
}

ulong WorkThread::lastErrorCode() const
{
  return static_cast<ulong>(lastErrorCode_.load());
}

bool WorkThread::hasError() const
{
  return lastErrorCode_.load()!=0;
}

void WorkThread::cahcel()
{
  process_.cancel();
}

void WorkThread::run()
{
  try
   {
     process_.start();
     Bicycle::ServerPipe& pipe= process_.stdOut();
     pipe.setTimeOut(30000);

     const size_t bufferSize= 256;
     char buffer[bufferSize]={'\0'};
     ulong length= 0;
     do
     {
       length= pipe.read(buffer,bufferSize);
       if(length)
       {
         std::string data = decodeOEM_ ? Bicycle::fromOEM(std::string(buffer,length))
                                       : std::string(buffer,length);
         if(mainWindowHandle_)
          {
            SendMessage(mainWindowHandle_,
                        readDataMessage_,
                        static_cast<WPARAM>(data.size()),
                        reinterpret_cast<LPARAM>(data.data()));
          }
       }
     }
     while(length && ! this->isInterruptionRequested() );
   }
   catch(const Bicycle::SystemException& e)
   {
      lastErrorCode_ = static_cast<LONG>(e.code());
   }

   if(mainWindowHandle_)
   {
     SendMessage(mainWindowHandle_,
                 finishedMessage_,
                 0,
                 0);
   }
}
//-------------------------------------------------------------------------------------
//
//-------------------------------------------------------------------------------------
work_thread bi_c_process_create_and_start(const wchar_t *app_name,
                                    const wchar_t *cmd_line,
                                    const wchar_t *current_dir,
                                    HWND mainWindowHandle,
                                    UINT readDataMessage,
                                    UINT finishedMessage,
                                    bool decodeOEM)
{
  WorkThread* workThread=
    new WorkThread(make_std_string(app_name),
                   make_std_string(cmd_line),
                   make_std_string(current_dir),
                   mainWindowHandle,
                   readDataMessage,
                   finishedMessage,
                   decodeOEM);

  workThread->start();
  return workThread;
}
//-------------------------------------------------------------------------------------
void bi_c_process_cancel(work_thread thread)
{
  WorkThread* t = reinterpret_cast<WorkThread*>(thread);
  t->requestInterruption();
  t->cahcel();
}
//-------------------------------------------------------------------------------------
ulong bi_c_process_wait_for_finished(work_thread thread, ulong msecs)
{
   WorkThread* t = reinterpret_cast<WorkThread*>(thread);
   return WaitForSingleObject(reinterpret_cast<HANDLE>(t->handle()), msecs);
}
//-------------------------------------------------------------------------------------
void bi_c_process_destroy(work_thread thread)
{
   WorkThread* t = reinterpret_cast<WorkThread*>(thread);
   delete t;
}
//-------------------------------------------------------------------------------------
ulong bi_c_process_work_thread_handle(work_thread thread)
{
  WorkThread* t = reinterpret_cast<WorkThread*>(thread);
  return t->handle();
}
//-------------------------------------------------------------------------------------
ulong bi_c_process_exit_code(work_thread thread)
{
  WorkThread* t = reinterpret_cast<WorkThread*>(thread);
  return t->exitCode();
}
//-------------------------------------------------------------------------------------
const char * bi_c_process_last_error(work_thread thread)
{
  WorkThread* t = reinterpret_cast<WorkThread*>(thread);
  return t->lastError().c_str();
}
//-------------------------------------------------------------------------------------
bool bi_c_process_has_error(work_thread thread)
{
  WorkThread* t = reinterpret_cast<WorkThread*>(thread);
  return t->hasError();
}
//-------------------------------------------------------------------------------------
ulong bi_c_process_last_error_code(work_thread thread)
{
  WorkThread* t = reinterpret_cast<WorkThread*>(thread);
  return t->lastErrorCode();
}
//-------------------------------------------------------------------------------------
