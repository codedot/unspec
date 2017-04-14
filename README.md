Implementation of [IEEE 1003.1-2016](http://pubs.opengroup.org/onlinepubs/9699919799/) with all the [options](http://pubs.opengroup.org/onlinepubs/9699919799/basedefs/V1_chap02.html#tag_02_01_06) disabled and [system limits](http://pubs.opengroup.org/onlinepubs/9699919799/basedefs/limits.h.html#tag_13_24) set to their minimum acceptable values. Implementation is real-time in the sense of implementation-defined system clock which need not correspond to real-time clock.

### Requirements

1. Implementation supports exactly one user ID, namely 0. Every possible login name (see `_POSIX_LOGIN_NAME_MAX`) has the same user ID and its home directory set to `/`. Implementation supports multiple logins.
2. System boot has finished exactly once before any login until a system crash. Any system crash shall be followed by system reboot.
3. Implementation has exactly one file system with its root at `/` which may be non-conforming.
4. Any actions that are described as producing implementation-defined, unspecified, or undefined results or where implementations may vary as well as use of obsolescent facilities shall immediately be followed by indicating an error message pointing to the relevant area of IEEE 1003.1-2008. System halt shall follow that error when allowed. Otherwise, corresponding utility failure exit shall follow the error unless required to survive.

## Rationale

Since C-Language Development Utilities are optional functionality, and the `c99` utility is the only way to compile an application, System Interfaces are not required to be actually implemented. That is, mandatory Shell and Utilities are the only functionality which is required to be implemented, of course, in conformance with Base Definitions and System Interfaces.

The file system may be non-conforming (for example, legacy file systems for which `_POSIX_NO_TRUNC` is false, case-insensitive file systems, or network file systems) because any Strictly Conforming POSIX Application is required to tolerate and permitted to adapt to the presence or absence of optional facilities, and the latter include non-conforming file systems.

Taking into account mandatory IPv4 support and that no other hardware interfaces are specified, the only user interface for UNIX that can be implemented as a Strictly Conforming POSIX Application is a Web terminal. System clock is not required to correspond to wall clock in order to allow implementation to stop background processes when no login is being used.

Implementation is required to follow the limitations in order to produce environment for developing and testing a Strictly Conforming POSIX Application. However, implementation may have a separate mode with different limitations and some optional facilities enabled for other applications.
