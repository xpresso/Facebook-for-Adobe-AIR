/*
  Copyright Facebook Inc.

  Licensed under the Apache License, Version 2.0 (the "License");
  you may not use this file except in compliance with the License.
  You may obtain a copy of the License at

      http://www.apache.org/licenses/LICENSE-2.0

  Unless required by applicable law or agreed to in writing, software
  distributed under the License is distributed on an "AS IS" BASIS,
  WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
  See the License for the specific language governing permissions and
  limitations under the License.
 */
package fb.util {
  import flash.filesystem.File;
  import flash.filesystem.FileMode;
  import flash.filesystem.FileStream;

  import mx.controls.Alert;

  public class Output {
    private static var verbose:Boolean = false;
    private static var debugFile:File =
      File.desktopDirectory.resolvePath("air_debug.txt");
    private static var debugStream:FileStream = new FileStream();
    private static var loggedItems:Array = new Array();

    // Trace
    public static function log(... rest):void {
      if (!verbose) return;
      for each (var item:* in rest)
        loggedItems.push(item);
    }

    // Trace no matter what
    public static function bug(... rest):void {
      for each (var item:* in rest) {
        loggedItems.push(item);
        trace(pretty(item));
      }
    }
    
    // Trace error no matter what
    public static function error(... rest):void {
      for each (var item:* in rest) {
        loggedItems.push(item);
        trace(pretty(item));
      }
    }
    
    // File shit
    public static function logDump():void {
      debugStream.open(debugFile, FileMode.WRITE);
      for each (var item:* in loggedItems)
        debugStream.writeUTFBytes(pretty(item));
      debugStream.close();
    }

    // Assert the thing which is not profane
    public static function assert(assertion:Boolean, ... rest):void {
      if (!assertion) for each (var item:* in rest) error(item);
    }

    // Alert
    public static function alert(item:*):void {
      Alert.show(pretty(item));
    }

    // Take an object and turn it into a pretty json-encoded string
    public static function pretty(item:*, preTab:String = ""):String {
      if (item is Array) {
        var i:int = 0;
        var a:String = "[\n";
        for each (var entry:* in item) {
          a += preTab + "  " + i + " - " + pretty(entry, preTab + "  ");
          i++;
        }
        a += preTab + "]\n";
        return a;
      }

      if (item is String)
        return "\"" + item + "\"\n";
      if (item is Boolean ||
          item is Number ||
          item is uint ||
          item is int)
        return String(item) + "\n";

      if (item is Object) {
        var o:String = "{\n";
        for (var key:String in item) {
          o += preTab + "  " + key + ":" + pretty(item[key], preTab + "  ");
        }
        o += preTab + "}\n";
        return o;
      }

      return String(item) + "\n";
    }
  }
}
