::
:: Licensed under the Apache License, Version 2.0 (the "License");
:: you may not use this file except in compliance with the License.
:: You may obtain a copy of the License at
::
::     http://www.apache.org/licenses/LICENSE-2.0
::
:: Unless required by applicable law or agreed to in writing, software
:: distributed under the License is distributed on an "AS IS" BASIS,
:: WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
:: See the License for the specific language governing permissions and
:: limitations under the License.
::

::
:: Appveyor install script for CYGWIN
:: Installs third party packages we need for a cmake build
::

@ECHO OFF
SETLOCAL EnableDelayedExpansion

CD build\appveyor                          || EXIT /B
CALL cl_banner_install.bat                 || EXIT /B
CALL cl_setenv.bat                         || EXIT /B
CALL cl_showenv.bat                        || EXIT /B

::
:: Upgrades cygwin to the latest, if you want...
::
:: appveyor DownloadFile "https://cygwin.com/setup-x86_64.exe"
:: setup-x86_64.exe --quiet-mode --wait --upgrade-also --packages="gcc-g++"

::
:: Install apt-cyg for package management
::

%BASH% -lc "wget rawgit.com/transcode-open/apt-cyg/master/apt-cyg && install apt-cyg /bin && rm -f apt-cyg" || EXIT /B
%BASH% -lc "apt-cyg update" || EXIT /B
%BASH% -lc "apt-cyg install bison cmake flex gcc-g++ libboost-devel libevent-devel make openssl-devel xz zlib-devel"

::
:: We need a newer version of cmake, the one cygwin provides is too old
:: to recognize the version of boost.  Luckily there is a pre-release
:: one available, however cygwin's own setup program has no command line
:: option to allow access to test packages!
::

%BASH% -lc "apt-cyg remove cmake"
%BASH% -lc "cd / && wget http://mirror.clarkson.edu/cygwin/x86_64/release/cmake/cmake-3.14.5-1.tar.xz && tar xJf cmake-3.14.5-1.tar.xz && hash -r && cmake --version"
