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

{ pkgs ? import <nixpkgs> {}, url, name ? url, ... }:
  pkgs.stdenv.mkDerivation {
    name = name;
    buildInputs = [ pkgs.chromium ];
    phases = [
      "patchPhase"
      "configurePhase"
      "buildPhase"
      "checkPhase"
      "installPhase"
      "fixupPhase"
      "installCheckPhase"
      "distPhase"
    ];
    installPhase = ''
      mkdir -p "$out/bin"
      echo '#!${pkgs.stdenv.shell}' >> "$out/bin/"'${name}'
      echo "exec chromium --app='${url}'" >> "$out/bin/"'${name}'
      chmod +x "$out/bin/"'${name}'
    '';
  }
