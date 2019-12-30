# Copyright (C) 2019  Oakes, Gregory <gregoryoakes@fastmail.com>
# Author: Oakes, Gregory <gregory.oakes@fastmail.com>
#
# This program is free software: you can redistribute it and/or modify
# it under the terms of the GNU General Public License as published by
# the Free Software Foundation, either version 3 of the License, or
# (at your option) any later version.
#
# This program is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU General Public License for more details.
#
# You should have received a copy of the GNU General Public License
# along with this program.  If not, see <http://www.gnu.org/licenses/>.

{ pkgs ? import <nixpkgs> {}
, url
, name ? url
, desktopItem ? {}
, ...
}:
  let
    xdgDefault = {
      name = name;
      exec = "${base}/bin/${name}";
      icon = builtins.fetchurl {url = "${url}/favicon.ico";};
      startupNotify = "true";
      desktopName = with pkgs.lib;
        (toUpper (substring 0 1 name) + substring 1 (-1) name);
    };
    base = pkgs.writeScriptBin name ''
      #!${pkgs.runtimeShell}
      exec ${pkgs.chromium}/bin/chromium --app=${pkgs.lib.escapeShellArg url}
    '';
    thisDesktopItem = pkgs.makeDesktopItem (xdgDefault // desktopItem);
  in
  pkgs.buildEnv {
    name = name;
    paths = [ base thisDesktopItem ];
  }
