/* -----------------------------------------------------------------------------
 * director.swg
 *
 * This file contains support for director classes so that C# proxy
 * methods can be called from C++.
 * ----------------------------------------------------------------------------- */

#if defined(DEBUG_DIRECTOR_OWNED)
#include <iostream>
#endif
#include <string>
#include <exception>

namespace Swig {
  /* Director base class - not currently used in C# directors */
  class Director {
  };

  /* Base class for director exceptions */
  class DirectorException : public std::exception {
  protected:
    std::string swig_msg;

  public:
    DirectorException(const char *msg) : swig_msg(msg) {
    }

    DirectorException(const std::string &msg) : swig_msg(msg) {
    }

    virtual ~DirectorException() throw() {
    }

    const char *what() const throw() {
      return swig_msg.c_str();
    }
  };

  /* Pure virtual method exception */
  class DirectorPureVirtualException : public DirectorException {
  public:
    DirectorPureVirtualException(const char *msg) : DirectorException(std::string("Attempt to invoke pure virtual method ") + msg) {
    }

    static void raise(const char *msg) {
      throw DirectorPureVirtualException(msg);
    }
  };

#if defined(SWIG_DIRECTORS_MONO_AOT_COMPATIBILITY)
  /* Represents a GCHandle to a callback */
  typedef void* GCHandle;

  /* Own a GCHandle and free it automatically */
  class OwnedGCHandle
  {
    public:
      OwnedGCHandle() : gcHandle(0) {
      }

      OwnedGCHandle& operator=(GCHandle handle) {
        gcHandle = handle;
        return *this;
      }

      operator GCHandle() {
        return gcHandle;
      }

      bool operator!() {
        return !gcHandle;
      }

      ~OwnedGCHandle() {
        if (gcHandle) {
          SWIG_csharp_gchandle_callback(gcHandle);
        }
      }

    private:
      OwnedGCHandle& operator=(const OwnedGCHandle&);
      OwnedGCHandle(const OwnedGCHandle&);

      GCHandle gcHandle;
  };
#endif
}

