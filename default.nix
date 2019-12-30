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

{ 
  pkgs ? import <nixpkgs> {}, 
  url, 
  name ? url ,
  desktop ? true,
  desktop-name ? name
}:
with pkgs; let

  launcher = writeShellScriptBin "${name}" ''
    exec ${chromium}/bin/chromium --app=${lib.escapeShellArg url}
  '';

  desktopFile = writeTextFile {
    name = "${name}-desktop";
    destination = "/share/applications/${name}.desktop";
    text = ''
    [Desktop Entry]
    Type=Application
    Name=${desktop-name}
    Exec=${launcher}/bin/${name}
    Terminal=false
    '';
  };

in 
symlinkJoin {
   name = "${name}-bundle";
   paths = [launcher] ++ lib.optional desktop desktopFile;
}
