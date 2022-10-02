![](/Haiku/Rsrc/Blackbox.png?raw=true)
# BlackBox-Haiku

[BlackBox Component Builder](http://blackboxframework.org/) port to [Haiku operating system](https://www.haiku-os.org/).

Only 32 bit x86 is supported because 64 bit Component Pascal compiler is not yet available.

![](/Haiku/Rsrc/Screenshot.png?raw=true)

Some technical details:

* This port directly use Haiku C++ API without additional C binding librares. It partially implements Intel Itanium ABI to interact with Haiku dynamic libraries. Old GCC2 ABI is not supported. C++ ABI is not directly supported by compiler, so vtables are manually defined and non-vtable methods are declared as regular procedures with this as first argument. See modules HaikuCpp, HaikuCppUtils, HaikuBeDecls for details. Haiku API declarations are incomplete and written on demand. It will be nice to make some LLVM automatic declaration generator in future.

* Haiku intensively use threads. Each window must run in separate thread. So ability to access Blackbox envinroment (called "native envinroment" in code, unsafe and operating system envinroment is called "host envinroment") by multiple threads has been introduced. Only one thread can access native envinroment, it is controlled by Kernel.nativeCS recursive lock. Module HostThreadSections has been introduced to control transfer between host and native envinroment. If thread want to access native envinroment, it should wrap native code to NativeSection.Enter/Leave calls, calls can be nested. If some other thread is already inside native envinroment, it will wait until another thread leave native envinroment. Native code can execute host code with temponary exit from native envinroment, allowing to enter native envinroment by another thread. It can be done by wrapping host code to HostSection.Enter/Leave calls. Calling HostSection.Enter and then immediately HostSection.Leave give chance an another thread to enter native envinroment. HostThreadSections.Yield is provided for such operation.

* Exception handling API was changed. Now Kernel.TryContext.Enter/Leave is used to protect code from exceptions. Then calling TryContext.Enter first time, it returns zero. If exception occurs, execution will continue from last TryContext.Enter, but return non-zero value. TryContext.Leave will remove TryContext from context stack. If removed context is not top context in context stack, upper contexts will be also removed, so forgotten TryContext.Leave call will not cause critical issues.

* OS locks generally should be released in native mode to prevent deadlocks. When implementing OS callbacks, lock should be released before entering native mode and reacquired after exiting native mode. TryContext also should be used to avoid application crash. See usage examples in HostWindows module.

__Warning__: port is in progress and incomplete. Some features are not working.

Known issues:
* ~~Open/save dialogs are not working.~~ Done.
* ~~Save confirmation is not implemented. Changes will be lost when closing window.~~ Done.
* Drag&drop is working only inside Blackbox application.
* ~~Popup menu is not working. Focus view-based menu items display is not working, all menu items are displayed. Menu guards are not implemented.~~ Done.
* ~~Mouse pointer shapes are not implemented.~~ Done.
* ~~Window placement is too trivial.~~ Done.

Build instructions:

1. Open `Tool.odc`.
2. Click on commander icon before `TestModList.Compile`.
3. Click on commander icon before `DevElfLinker2.Link`. It will produce `Blackbox.so` executable.
4. Execute `SetResources.sh` in Terminal. Blackbox root directory should be current working directory. It will attach resources to Blackbox executable. Resources are necessary for file associations.
