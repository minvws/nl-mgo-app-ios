var MgoFhirData = function(exports) {
  "use strict";var __defProp = Object.defineProperty;
var __defNormalProp = (obj, key, value) => key in obj ? __defProp(obj, key, { enumerable: true, configurable: true, writable: true, value }) : obj[key] = value;
var __publicField = (obj, key, value) => __defNormalProp(obj, typeof key !== "symbol" ? key + "" : key, value);

  function isInteger(value2) {
    return INTEGER_REGEX.test(value2);
  }
  const INTEGER_REGEX = /^-?[0-9]+$/;
  function isNumber(value2) {
    return NUMBER_REGEX.test(value2);
  }
  const NUMBER_REGEX = /^-?(?:0|[1-9]\d*)(?:\.\d+)?(?:[eE][+-]?\d+)?$/;
  function isSafeNumber(value2, config) {
    const num = parseFloat(value2);
    const str = String(num);
    const v = extractSignificantDigits(value2);
    const s = extractSignificantDigits(str);
    if (v === s) {
      return true;
    }
    return false;
  }
  let UnsafeNumberReason = /* @__PURE__ */ function(UnsafeNumberReason2) {
    UnsafeNumberReason2["underflow"] = "underflow";
    UnsafeNumberReason2["overflow"] = "overflow";
    UnsafeNumberReason2["truncate_integer"] = "truncate_integer";
    UnsafeNumberReason2["truncate_float"] = "truncate_float";
    return UnsafeNumberReason2;
  }({});
  function getUnsafeNumberReason(value2) {
    if (isSafeNumber(value2)) {
      return void 0;
    }
    if (isInteger(value2)) {
      return UnsafeNumberReason.truncate_integer;
    }
    const num = parseFloat(value2);
    if (!isFinite(num)) {
      return UnsafeNumberReason.overflow;
    }
    if (num === 0) {
      return UnsafeNumberReason.underflow;
    }
    return UnsafeNumberReason.truncate_float;
  }
  function extractSignificantDigits(value2) {
    return value2.replace(EXPONENTIAL_PART_REGEX, "").replace(DOT_REGEX, "").replace(TRAILING_ZEROS_REGEX, "").replace(LEADING_MINUS_AND_ZEROS_REGEX, "");
  }
  const EXPONENTIAL_PART_REGEX = /[eE][+-]?\d+$/;
  const LEADING_MINUS_AND_ZEROS_REGEX = /^-?(0*)?/;
  const DOT_REGEX = /\./;
  const TRAILING_ZEROS_REGEX = /0+$/;
  class LosslessNumber {
    constructor(value2) {
      // numeric value as string
      // type information
      __publicField(this, "isLosslessNumber", true);
      if (!isNumber(value2)) {
        throw new Error('Invalid number (value: "' + value2 + '")');
      }
      this.value = value2;
    }
    /**
     * Get the value of the LosslessNumber as number or bigint.
     *
     * - a number is returned for safe numbers and decimal values that only lose some insignificant digits
     * - a bigint is returned for big integer numbers
     * - an Error is thrown for values that will overflow or underflow
     *
     * Note that you can implement your own strategy for conversion by just getting the value as string
     * via .toString(), and using util functions like isInteger, isSafeNumber, getUnsafeNumberReason,
     * and toSafeNumberOrThrow to convert it to a numeric value.
     */
    valueOf() {
      const unsafeReason = getUnsafeNumberReason(this.value);
      if (unsafeReason === void 0 || unsafeReason === UnsafeNumberReason.truncate_float) {
        return parseFloat(this.value);
      }
      if (isInteger(this.value)) {
        return BigInt(this.value);
      }
      throw new Error(`Cannot safely convert to number: the value '${this.value}' would ${unsafeReason} and become ${parseFloat(this.value)}`);
    }
    /**
     * Get the value of the LosslessNumber as string.
     */
    toString() {
      return this.value;
    }
    // Note: we do NOT implement a .toJSON() method, and you should not implement
    // or use that, it cannot safely turn the numeric value in the string into
    // stringified JSON since it has to be parsed into a number first.
  }
  function isLosslessNumber(value2) {
    return value2 && typeof value2 === "object" && value2.isLosslessNumber === true || false;
  }
  function parseLosslessNumber(value2) {
    return new LosslessNumber(value2);
  }
  function revive(json, reviver) {
    return reviveValue({
      "": json
    }, "", json, reviver);
  }
  function reviveValue(context, key, value2, reviver) {
    if (Array.isArray(value2)) {
      return reviver.call(context, key, reviveArray(value2, reviver));
    } else if (value2 && typeof value2 === "object" && !isLosslessNumber(value2)) {
      return reviver.call(context, key, reviveObject(value2, reviver));
    } else {
      return reviver.call(context, key, value2);
    }
  }
  function reviveObject(object, reviver) {
    Object.keys(object).forEach((key) => {
      const value2 = reviveValue(object, key, object[key], reviver);
      if (value2 !== void 0) {
        object[key] = value2;
      } else {
        delete object[key];
      }
    });
    return object;
  }
  function reviveArray(array, reviver) {
    for (let i = 0; i < array.length; i++) {
      array[i] = reviveValue(array, i + "", array[i], reviver);
    }
    return array;
  }
  function parse$2(text, reviver) {
    let parseNumber = arguments.length > 2 && arguments[2] !== void 0 ? arguments[2] : parseLosslessNumber;
    let i = 0;
    const value2 = parseValue();
    expectValue(value2);
    expectEndOfInput();
    return reviver ? revive(value2, reviver) : value2;
    function parseObject() {
      if (text.charCodeAt(i) === codeOpeningBrace) {
        i++;
        skipWhitespace();
        const object = {};
        let initial = true;
        while (i < text.length && text.charCodeAt(i) !== codeClosingBrace) {
          if (!initial) {
            eatComma();
            skipWhitespace();
          } else {
            initial = false;
          }
          const start = i;
          const key = parseString();
          if (key === void 0) {
            throwObjectKeyExpected();
            return;
          }
          skipWhitespace();
          eatColon();
          const value3 = parseValue();
          if (value3 === void 0) {
            throwObjectValueExpected();
            return;
          }
          if (Object.prototype.hasOwnProperty.call(object, key) && !isDeepEqual(value3, object[key])) {
            throwDuplicateKey(key, start + 1);
          }
          object[key] = value3;
        }
        if (text.charCodeAt(i) !== codeClosingBrace) {
          throwObjectKeyOrEndExpected();
        }
        i++;
        return object;
      }
    }
    function parseArray() {
      if (text.charCodeAt(i) === codeOpeningBracket) {
        i++;
        skipWhitespace();
        const array = [];
        let initial = true;
        while (i < text.length && text.charCodeAt(i) !== codeClosingBracket) {
          if (!initial) {
            eatComma();
          } else {
            initial = false;
          }
          const value3 = parseValue();
          expectArrayItem(value3);
          array.push(value3);
        }
        if (text.charCodeAt(i) !== codeClosingBracket) {
          throwArrayItemOrEndExpected();
        }
        i++;
        return array;
      }
    }
    function parseValue() {
      skipWhitespace();
      const value3 = parseString() ?? parseNumeric() ?? parseObject() ?? parseArray() ?? parseKeyword("true", true) ?? parseKeyword("false", false) ?? parseKeyword("null", null);
      skipWhitespace();
      return value3;
    }
    function parseKeyword(name, value3) {
      if (text.slice(i, i + name.length) === name) {
        i += name.length;
        return value3;
      }
    }
    function skipWhitespace() {
      while (isWhitespace(text.charCodeAt(i))) {
        i++;
      }
    }
    function parseString() {
      if (text.charCodeAt(i) === codeDoubleQuote) {
        i++;
        let result = "";
        while (i < text.length && text.charCodeAt(i) !== codeDoubleQuote) {
          if (text.charCodeAt(i) === codeBackslash) {
            const char = text[i + 1];
            const escapeChar = escapeCharacters[char];
            if (escapeChar !== void 0) {
              result += escapeChar;
              i++;
            } else if (char === "u") {
              if (isHex(text.charCodeAt(i + 2)) && isHex(text.charCodeAt(i + 3)) && isHex(text.charCodeAt(i + 4)) && isHex(text.charCodeAt(i + 5))) {
                result += String.fromCharCode(parseInt(text.slice(i + 2, i + 6), 16));
                i += 5;
              } else {
                throwInvalidUnicodeCharacter(i);
              }
            } else {
              throwInvalidEscapeCharacter(i);
            }
          } else {
            if (isValidStringCharacter(text.charCodeAt(i))) {
              result += text[i];
            } else {
              throwInvalidCharacter(text[i]);
            }
          }
          i++;
        }
        expectEndOfString();
        i++;
        return result;
      }
    }
    function parseNumeric() {
      const start = i;
      if (text.charCodeAt(i) === codeMinus) {
        i++;
        expectDigit(start);
      }
      if (text.charCodeAt(i) === codeZero) {
        i++;
      } else if (isNonZeroDigit(text.charCodeAt(i))) {
        i++;
        while (isDigit(text.charCodeAt(i))) {
          i++;
        }
      }
      if (text.charCodeAt(i) === codeDot) {
        i++;
        expectDigit(start);
        while (isDigit(text.charCodeAt(i))) {
          i++;
        }
      }
      if (text.charCodeAt(i) === codeLowercaseE || text.charCodeAt(i) === codeUppercaseE) {
        i++;
        if (text.charCodeAt(i) === codeMinus || text.charCodeAt(i) === codePlus) {
          i++;
        }
        expectDigit(start);
        while (isDigit(text.charCodeAt(i))) {
          i++;
        }
      }
      if (i > start) {
        return parseNumber(text.slice(start, i));
      }
    }
    function eatComma() {
      if (text.charCodeAt(i) !== codeComma) {
        throw new SyntaxError(`Comma ',' expected after value ${gotAt()}`);
      }
      i++;
    }
    function eatColon() {
      if (text.charCodeAt(i) !== codeColon) {
        throw new SyntaxError(`Colon ':' expected after property name ${gotAt()}`);
      }
      i++;
    }
    function expectValue(value3) {
      if (value3 === void 0) {
        throw new SyntaxError(`JSON value expected ${gotAt()}`);
      }
    }
    function expectArrayItem(value3) {
      if (value3 === void 0) {
        throw new SyntaxError(`Array item expected ${gotAt()}`);
      }
    }
    function expectEndOfInput() {
      if (i < text.length) {
        throw new SyntaxError(`Expected end of input ${gotAt()}`);
      }
    }
    function expectDigit(start) {
      if (!isDigit(text.charCodeAt(i))) {
        const numSoFar = text.slice(start, i);
        throw new SyntaxError(`Invalid number '${numSoFar}', expecting a digit ${gotAt()}`);
      }
    }
    function expectEndOfString() {
      if (text.charCodeAt(i) !== codeDoubleQuote) {
        throw new SyntaxError(`End of string '"' expected ${gotAt()}`);
      }
    }
    function throwObjectKeyExpected() {
      throw new SyntaxError(`Quoted object key expected ${gotAt()}`);
    }
    function throwDuplicateKey(key, pos2) {
      throw new SyntaxError(`Duplicate key '${key}' encountered at position ${pos2}`);
    }
    function throwObjectKeyOrEndExpected() {
      throw new SyntaxError(`Quoted object key or end of object '}' expected ${gotAt()}`);
    }
    function throwArrayItemOrEndExpected() {
      throw new SyntaxError(`Array item or end of array ']' expected ${gotAt()}`);
    }
    function throwInvalidCharacter(char) {
      throw new SyntaxError(`Invalid character '${char}' ${pos()}`);
    }
    function throwInvalidEscapeCharacter(start) {
      const chars = text.slice(start, start + 2);
      throw new SyntaxError(`Invalid escape character '${chars}' ${pos()}`);
    }
    function throwObjectValueExpected() {
      throw new SyntaxError(`Object value expected after ':' ${pos()}`);
    }
    function throwInvalidUnicodeCharacter(start) {
      const chars = text.slice(start, start + 6);
      throw new SyntaxError(`Invalid unicode character '${chars}' ${pos()}`);
    }
    function pos() {
      return `at position ${i}`;
    }
    function got() {
      return i < text.length ? `but got '${text[i]}'` : "but reached end of input";
    }
    function gotAt() {
      return got() + " " + pos();
    }
  }
  function isWhitespace(code2) {
    return code2 === codeSpace || code2 === codeNewline || code2 === codeTab || code2 === codeReturn;
  }
  function isHex(code2) {
    return code2 >= codeZero && code2 <= codeNine || code2 >= codeUppercaseA && code2 <= codeUppercaseF || code2 >= codeLowercaseA && code2 <= codeLowercaseF;
  }
  function isDigit(code2) {
    return code2 >= codeZero && code2 <= codeNine;
  }
  function isNonZeroDigit(code2) {
    return code2 >= codeOne && code2 <= codeNine;
  }
  function isValidStringCharacter(code2) {
    return code2 >= 32 && code2 <= 1114111;
  }
  function isDeepEqual(a, b) {
    if (a === b) {
      return true;
    }
    if (Array.isArray(a) && Array.isArray(b)) {
      return a.length === b.length && a.every((item, index) => isDeepEqual(item, b[index]));
    }
    if (isObject(a) && isObject(b)) {
      const keys = [.../* @__PURE__ */ new Set([...Object.keys(a), ...Object.keys(b)])];
      return keys.every((key) => isDeepEqual(a[key], b[key]));
    }
    return false;
  }
  function isObject(value2) {
    return typeof value2 === "object" && value2 !== null;
  }
  const escapeCharacters = {
    '"': '"',
    "\\": "\\",
    "/": "/",
    b: "\b",
    f: "\f",
    n: "\n",
    r: "\r",
    t: "	"
    // note that \u is handled separately in parseString()
  };
  const codeBackslash = 92;
  const codeOpeningBrace = 123;
  const codeClosingBrace = 125;
  const codeOpeningBracket = 91;
  const codeClosingBracket = 93;
  const codeSpace = 32;
  const codeNewline = 10;
  const codeTab = 9;
  const codeReturn = 13;
  const codeDoubleQuote = 34;
  const codePlus = 43;
  const codeMinus = 45;
  const codeZero = 48;
  const codeOne = 49;
  const codeNine = 57;
  const codeComma = 44;
  const codeDot = 46;
  const codeColon = 58;
  const codeUppercaseA = 65;
  const codeLowercaseA = 97;
  const codeUppercaseE = 69;
  const codeLowercaseE = 101;
  const codeUppercaseF = 70;
  const codeLowercaseF = 102;
  function stringify(value2, replacer, space, numberStringifiers) {
    const resolvedSpace = resolveSpace(space);
    const replacedValue = typeof replacer === "function" ? replacer.call({
      "": value2
    }, "", value2) : value2;
    return stringifyValue(replacedValue, "");
    function stringifyValue(value3, indent) {
      if (Array.isArray(numberStringifiers)) {
        const stringifier = numberStringifiers.find((item) => item.test(value3));
        if (stringifier) {
          const str = stringifier.stringify(value3);
          if (typeof str !== "string" || !isNumber(str)) {
            throw new Error(`Invalid JSON number: output of a number stringifier must be a string containing a JSON number (output: ${str})`);
          }
          return str;
        }
      }
      if (typeof value3 === "boolean" || typeof value3 === "number" || typeof value3 === "string" || value3 === null || value3 instanceof Date || value3 instanceof Boolean || value3 instanceof Number || value3 instanceof String) {
        return JSON.stringify(value3);
      }
      if (value3 && value3.isLosslessNumber) {
        return value3.toString();
      }
      if (typeof value3 === "bigint") {
        return value3.toString();
      }
      if (Array.isArray(value3)) {
        return stringifyArray(value3, indent);
      }
      if (value3 && typeof value3 === "object") {
        return stringifyObject(value3, indent);
      }
      return void 0;
    }
    function stringifyArray(array, indent) {
      if (array.length === 0) {
        return "[]";
      }
      const childIndent = resolvedSpace ? indent + resolvedSpace : void 0;
      let str = resolvedSpace ? "[\n" : "[";
      for (let i = 0; i < array.length; i++) {
        const item = typeof replacer === "function" ? replacer.call(array, String(i), array[i]) : array[i];
        if (resolvedSpace) {
          str += childIndent;
        }
        if (typeof item !== "undefined" && typeof item !== "function") {
          str += stringifyValue(item, childIndent);
        } else {
          str += "null";
        }
        if (i < array.length - 1) {
          str += resolvedSpace ? ",\n" : ",";
        }
      }
      str += resolvedSpace ? "\n" + indent + "]" : "]";
      return str;
    }
    function stringifyObject(object, indent) {
      if (typeof object.toJSON === "function") {
        return stringify(object.toJSON(), replacer, space, void 0);
      }
      const keys = Array.isArray(replacer) ? replacer.map(String) : Object.keys(object);
      if (keys.length === 0) {
        return "{}";
      }
      const childIndent = resolvedSpace ? indent + resolvedSpace : void 0;
      let first = true;
      let str = resolvedSpace ? "{\n" : "{";
      keys.forEach((key) => {
        const value3 = typeof replacer === "function" ? replacer.call(object, key, object[key]) : object[key];
        if (includeProperty(key, value3)) {
          if (first) {
            first = false;
          } else {
            str += resolvedSpace ? ",\n" : ",";
          }
          const keyStr = JSON.stringify(key);
          str += resolvedSpace ? childIndent + keyStr + ": " : keyStr + ":";
          str += stringifyValue(value3, childIndent);
        }
      });
      str += resolvedSpace ? "\n" + indent + "}" : "}";
      return str;
    }
    function includeProperty(key, value3) {
      return typeof value3 !== "undefined" && typeof value3 !== "function" && typeof value3 !== "symbol";
    }
  }
  function resolveSpace(space) {
    if (typeof space === "number") {
      return " ".repeat(space);
    }
    if (typeof space === "string" && space !== "") {
      return space;
    }
    return void 0;
  }
  function losslessParse(text) {
    if (typeof text !== "string") {
      throw new Error("Input is not a (JSON) string");
    }
    return parse$2(text);
  }
  function losslessStringify(value2, format2 = false) {
    if (format2) {
      return stringify(value2, null, 2);
    }
    return stringify(value2);
  }
  function isFhirResource(value2, type) {
    const resource = value2;
    if (!type) {
      return typeof resource?.resourceType === "string" && !!resource?.resourceType.length;
    }
    return resource?.resourceType === type;
  }
  function isNullish(value2) {
    return value2 === void 0 || value2 === null;
  }
  function isNonNullish(value2) {
    return !isNullish(value2);
  }
  function map(items, iteratee, returnEmpty = false) {
    if (!items?.length) {
      return returnEmpty ? [] : void 0;
    }
    return items.map(iteratee).filter(isNonNullish);
  }
  function capitalizeFirstLetter(str) {
    if (!str) return str;
    return str.charAt(0).toUpperCase() + str.slice(1);
  }
  function getBundleResources(bundle) {
    const resources = bundle.entry?.map((entry) => entry.resource).filter(isNonNullish);
    if (!resources?.length) return [];
    return resources;
  }
  function getBundleResourcesJson(fhirBundleJson, formatResponse = false) {
    const fhirBundle = losslessParse(fhirBundleJson);
    if (!isFhirResource(fhirBundle, "Bundle")) {
      throw new Error(
        `input does not seem to be a Fhir Bundle. Received resourceType: "${fhirBundle?.resourceType}"`
      );
    }
    const resources = getBundleResources(fhirBundle);
    return losslessStringify(resources, formatResponse);
  }
  var FhirVersion = /* @__PURE__ */ ((FhirVersion2) => {
    FhirVersion2["R3"] = "R3";
    FhirVersion2["R4"] = "R4";
    return FhirVersion2;
  })(FhirVersion || {});
  var commonjsGlobal = typeof globalThis !== "undefined" ? globalThis : typeof window !== "undefined" ? window : typeof global !== "undefined" ? global : typeof self !== "undefined" ? self : {};
  var lodash = { exports: {} };
  /**
   * @license
   * Lodash <https://lodash.com/>
   * Copyright OpenJS Foundation and other contributors <https://openjsf.org/>
   * Released under MIT license <https://lodash.com/license>
   * Based on Underscore.js 1.8.3 <http://underscorejs.org/LICENSE>
   * Copyright Jeremy Ashkenas, DocumentCloud and Investigative Reporters & Editors
   */
  lodash.exports;
  (function(module, exports2) {
    (function() {
      var undefined$1;
      var VERSION = "4.17.21";
      var LARGE_ARRAY_SIZE = 200;
      var CORE_ERROR_TEXT = "Unsupported core-js use. Try https://npms.io/search?q=ponyfill.", FUNC_ERROR_TEXT = "Expected a function", INVALID_TEMPL_VAR_ERROR_TEXT = "Invalid `variable` option passed into `_.template`";
      var HASH_UNDEFINED = "__lodash_hash_undefined__";
      var MAX_MEMOIZE_SIZE = 500;
      var PLACEHOLDER = "__lodash_placeholder__";
      var CLONE_DEEP_FLAG = 1, CLONE_FLAT_FLAG = 2, CLONE_SYMBOLS_FLAG = 4;
      var COMPARE_PARTIAL_FLAG = 1, COMPARE_UNORDERED_FLAG = 2;
      var WRAP_BIND_FLAG = 1, WRAP_BIND_KEY_FLAG = 2, WRAP_CURRY_BOUND_FLAG = 4, WRAP_CURRY_FLAG = 8, WRAP_CURRY_RIGHT_FLAG = 16, WRAP_PARTIAL_FLAG = 32, WRAP_PARTIAL_RIGHT_FLAG = 64, WRAP_ARY_FLAG = 128, WRAP_REARG_FLAG = 256, WRAP_FLIP_FLAG = 512;
      var DEFAULT_TRUNC_LENGTH = 30, DEFAULT_TRUNC_OMISSION = "...";
      var HOT_COUNT = 800, HOT_SPAN = 16;
      var LAZY_FILTER_FLAG = 1, LAZY_MAP_FLAG = 2, LAZY_WHILE_FLAG = 3;
      var INFINITY = 1 / 0, MAX_SAFE_INTEGER = 9007199254740991, MAX_INTEGER = 17976931348623157e292, NAN = 0 / 0;
      var MAX_ARRAY_LENGTH = 4294967295, MAX_ARRAY_INDEX = MAX_ARRAY_LENGTH - 1, HALF_MAX_ARRAY_LENGTH = MAX_ARRAY_LENGTH >>> 1;
      var wrapFlags = [
        ["ary", WRAP_ARY_FLAG],
        ["bind", WRAP_BIND_FLAG],
        ["bindKey", WRAP_BIND_KEY_FLAG],
        ["curry", WRAP_CURRY_FLAG],
        ["curryRight", WRAP_CURRY_RIGHT_FLAG],
        ["flip", WRAP_FLIP_FLAG],
        ["partial", WRAP_PARTIAL_FLAG],
        ["partialRight", WRAP_PARTIAL_RIGHT_FLAG],
        ["rearg", WRAP_REARG_FLAG]
      ];
      var argsTag = "[object Arguments]", arrayTag = "[object Array]", asyncTag = "[object AsyncFunction]", boolTag = "[object Boolean]", dateTag = "[object Date]", domExcTag = "[object DOMException]", errorTag = "[object Error]", funcTag = "[object Function]", genTag = "[object GeneratorFunction]", mapTag = "[object Map]", numberTag = "[object Number]", nullTag = "[object Null]", objectTag = "[object Object]", promiseTag = "[object Promise]", proxyTag = "[object Proxy]", regexpTag = "[object RegExp]", setTag = "[object Set]", stringTag = "[object String]", symbolTag = "[object Symbol]", undefinedTag = "[object Undefined]", weakMapTag = "[object WeakMap]", weakSetTag = "[object WeakSet]";
      var arrayBufferTag = "[object ArrayBuffer]", dataViewTag = "[object DataView]", float32Tag = "[object Float32Array]", float64Tag = "[object Float64Array]", int8Tag = "[object Int8Array]", int16Tag = "[object Int16Array]", int32Tag = "[object Int32Array]", uint8Tag = "[object Uint8Array]", uint8ClampedTag = "[object Uint8ClampedArray]", uint16Tag = "[object Uint16Array]", uint32Tag = "[object Uint32Array]";
      var reEmptyStringLeading = /\b__p \+= '';/g, reEmptyStringMiddle = /\b(__p \+=) '' \+/g, reEmptyStringTrailing = /(__e\(.*?\)|\b__t\)) \+\n'';/g;
      var reEscapedHtml = /&(?:amp|lt|gt|quot|#39);/g, reUnescapedHtml = /[&<>"']/g, reHasEscapedHtml = RegExp(reEscapedHtml.source), reHasUnescapedHtml = RegExp(reUnescapedHtml.source);
      var reEscape = /<%-([\s\S]+?)%>/g, reEvaluate = /<%([\s\S]+?)%>/g, reInterpolate = /<%=([\s\S]+?)%>/g;
      var reIsDeepProp = /\.|\[(?:[^[\]]*|(["'])(?:(?!\1)[^\\]|\\.)*?\1)\]/, reIsPlainProp = /^\w*$/, rePropName = /[^.[\]]+|\[(?:(-?\d+(?:\.\d+)?)|(["'])((?:(?!\2)[^\\]|\\.)*?)\2)\]|(?=(?:\.|\[\])(?:\.|\[\]|$))/g;
      var reRegExpChar = /[\\^$.*+?()[\]{}|]/g, reHasRegExpChar = RegExp(reRegExpChar.source);
      var reTrimStart = /^\s+/;
      var reWhitespace = /\s/;
      var reWrapComment = /\{(?:\n\/\* \[wrapped with .+\] \*\/)?\n?/, reWrapDetails = /\{\n\/\* \[wrapped with (.+)\] \*/, reSplitDetails = /,? & /;
      var reAsciiWord = /[^\x00-\x2f\x3a-\x40\x5b-\x60\x7b-\x7f]+/g;
      var reForbiddenIdentifierChars = /[()=,{}\[\]\/\s]/;
      var reEscapeChar = /\\(\\)?/g;
      var reEsTemplate = /\$\{([^\\}]*(?:\\.[^\\}]*)*)\}/g;
      var reFlags = /\w*$/;
      var reIsBadHex = /^[-+]0x[0-9a-f]+$/i;
      var reIsBinary = /^0b[01]+$/i;
      var reIsHostCtor = /^\[object .+?Constructor\]$/;
      var reIsOctal = /^0o[0-7]+$/i;
      var reIsUint = /^(?:0|[1-9]\d*)$/;
      var reLatin = /[\xc0-\xd6\xd8-\xf6\xf8-\xff\u0100-\u017f]/g;
      var reNoMatch = /($^)/;
      var reUnescapedString = /['\n\r\u2028\u2029\\]/g;
      var rsAstralRange = "\\ud800-\\udfff", rsComboMarksRange = "\\u0300-\\u036f", reComboHalfMarksRange = "\\ufe20-\\ufe2f", rsComboSymbolsRange = "\\u20d0-\\u20ff", rsComboRange = rsComboMarksRange + reComboHalfMarksRange + rsComboSymbolsRange, rsDingbatRange = "\\u2700-\\u27bf", rsLowerRange = "a-z\\xdf-\\xf6\\xf8-\\xff", rsMathOpRange = "\\xac\\xb1\\xd7\\xf7", rsNonCharRange = "\\x00-\\x2f\\x3a-\\x40\\x5b-\\x60\\x7b-\\xbf", rsPunctuationRange = "\\u2000-\\u206f", rsSpaceRange = " \\t\\x0b\\f\\xa0\\ufeff\\n\\r\\u2028\\u2029\\u1680\\u180e\\u2000\\u2001\\u2002\\u2003\\u2004\\u2005\\u2006\\u2007\\u2008\\u2009\\u200a\\u202f\\u205f\\u3000", rsUpperRange = "A-Z\\xc0-\\xd6\\xd8-\\xde", rsVarRange = "\\ufe0e\\ufe0f", rsBreakRange = rsMathOpRange + rsNonCharRange + rsPunctuationRange + rsSpaceRange;
      var rsApos = "['’]", rsAstral = "[" + rsAstralRange + "]", rsBreak = "[" + rsBreakRange + "]", rsCombo = "[" + rsComboRange + "]", rsDigits = "\\d+", rsDingbat = "[" + rsDingbatRange + "]", rsLower = "[" + rsLowerRange + "]", rsMisc = "[^" + rsAstralRange + rsBreakRange + rsDigits + rsDingbatRange + rsLowerRange + rsUpperRange + "]", rsFitz = "\\ud83c[\\udffb-\\udfff]", rsModifier = "(?:" + rsCombo + "|" + rsFitz + ")", rsNonAstral = "[^" + rsAstralRange + "]", rsRegional = "(?:\\ud83c[\\udde6-\\uddff]){2}", rsSurrPair = "[\\ud800-\\udbff][\\udc00-\\udfff]", rsUpper = "[" + rsUpperRange + "]", rsZWJ = "\\u200d";
      var rsMiscLower = "(?:" + rsLower + "|" + rsMisc + ")", rsMiscUpper = "(?:" + rsUpper + "|" + rsMisc + ")", rsOptContrLower = "(?:" + rsApos + "(?:d|ll|m|re|s|t|ve))?", rsOptContrUpper = "(?:" + rsApos + "(?:D|LL|M|RE|S|T|VE))?", reOptMod = rsModifier + "?", rsOptVar = "[" + rsVarRange + "]?", rsOptJoin = "(?:" + rsZWJ + "(?:" + [rsNonAstral, rsRegional, rsSurrPair].join("|") + ")" + rsOptVar + reOptMod + ")*", rsOrdLower = "\\d*(?:1st|2nd|3rd|(?![123])\\dth)(?=\\b|[A-Z_])", rsOrdUpper = "\\d*(?:1ST|2ND|3RD|(?![123])\\dTH)(?=\\b|[a-z_])", rsSeq = rsOptVar + reOptMod + rsOptJoin, rsEmoji = "(?:" + [rsDingbat, rsRegional, rsSurrPair].join("|") + ")" + rsSeq, rsSymbol = "(?:" + [rsNonAstral + rsCombo + "?", rsCombo, rsRegional, rsSurrPair, rsAstral].join("|") + ")";
      var reApos = RegExp(rsApos, "g");
      var reComboMark = RegExp(rsCombo, "g");
      var reUnicode = RegExp(rsFitz + "(?=" + rsFitz + ")|" + rsSymbol + rsSeq, "g");
      var reUnicodeWord = RegExp([
        rsUpper + "?" + rsLower + "+" + rsOptContrLower + "(?=" + [rsBreak, rsUpper, "$"].join("|") + ")",
        rsMiscUpper + "+" + rsOptContrUpper + "(?=" + [rsBreak, rsUpper + rsMiscLower, "$"].join("|") + ")",
        rsUpper + "?" + rsMiscLower + "+" + rsOptContrLower,
        rsUpper + "+" + rsOptContrUpper,
        rsOrdUpper,
        rsOrdLower,
        rsDigits,
        rsEmoji
      ].join("|"), "g");
      var reHasUnicode = RegExp("[" + rsZWJ + rsAstralRange + rsComboRange + rsVarRange + "]");
      var reHasUnicodeWord = /[a-z][A-Z]|[A-Z]{2}[a-z]|[0-9][a-zA-Z]|[a-zA-Z][0-9]|[^a-zA-Z0-9 ]/;
      var contextProps = [
        "Array",
        "Buffer",
        "DataView",
        "Date",
        "Error",
        "Float32Array",
        "Float64Array",
        "Function",
        "Int8Array",
        "Int16Array",
        "Int32Array",
        "Map",
        "Math",
        "Object",
        "Promise",
        "RegExp",
        "Set",
        "String",
        "Symbol",
        "TypeError",
        "Uint8Array",
        "Uint8ClampedArray",
        "Uint16Array",
        "Uint32Array",
        "WeakMap",
        "_",
        "clearTimeout",
        "isFinite",
        "parseInt",
        "setTimeout"
      ];
      var templateCounter = -1;
      var typedArrayTags = {};
      typedArrayTags[float32Tag] = typedArrayTags[float64Tag] = typedArrayTags[int8Tag] = typedArrayTags[int16Tag] = typedArrayTags[int32Tag] = typedArrayTags[uint8Tag] = typedArrayTags[uint8ClampedTag] = typedArrayTags[uint16Tag] = typedArrayTags[uint32Tag] = true;
      typedArrayTags[argsTag] = typedArrayTags[arrayTag] = typedArrayTags[arrayBufferTag] = typedArrayTags[boolTag] = typedArrayTags[dataViewTag] = typedArrayTags[dateTag] = typedArrayTags[errorTag] = typedArrayTags[funcTag] = typedArrayTags[mapTag] = typedArrayTags[numberTag] = typedArrayTags[objectTag] = typedArrayTags[regexpTag] = typedArrayTags[setTag] = typedArrayTags[stringTag] = typedArrayTags[weakMapTag] = false;
      var cloneableTags = {};
      cloneableTags[argsTag] = cloneableTags[arrayTag] = cloneableTags[arrayBufferTag] = cloneableTags[dataViewTag] = cloneableTags[boolTag] = cloneableTags[dateTag] = cloneableTags[float32Tag] = cloneableTags[float64Tag] = cloneableTags[int8Tag] = cloneableTags[int16Tag] = cloneableTags[int32Tag] = cloneableTags[mapTag] = cloneableTags[numberTag] = cloneableTags[objectTag] = cloneableTags[regexpTag] = cloneableTags[setTag] = cloneableTags[stringTag] = cloneableTags[symbolTag] = cloneableTags[uint8Tag] = cloneableTags[uint8ClampedTag] = cloneableTags[uint16Tag] = cloneableTags[uint32Tag] = true;
      cloneableTags[errorTag] = cloneableTags[funcTag] = cloneableTags[weakMapTag] = false;
      var deburredLetters = {
        // Latin-1 Supplement block.
        "À": "A",
        "Á": "A",
        "Â": "A",
        "Ã": "A",
        "Ä": "A",
        "Å": "A",
        "à": "a",
        "á": "a",
        "â": "a",
        "ã": "a",
        "ä": "a",
        "å": "a",
        "Ç": "C",
        "ç": "c",
        "Ð": "D",
        "ð": "d",
        "È": "E",
        "É": "E",
        "Ê": "E",
        "Ë": "E",
        "è": "e",
        "é": "e",
        "ê": "e",
        "ë": "e",
        "Ì": "I",
        "Í": "I",
        "Î": "I",
        "Ï": "I",
        "ì": "i",
        "í": "i",
        "î": "i",
        "ï": "i",
        "Ñ": "N",
        "ñ": "n",
        "Ò": "O",
        "Ó": "O",
        "Ô": "O",
        "Õ": "O",
        "Ö": "O",
        "Ø": "O",
        "ò": "o",
        "ó": "o",
        "ô": "o",
        "õ": "o",
        "ö": "o",
        "ø": "o",
        "Ù": "U",
        "Ú": "U",
        "Û": "U",
        "Ü": "U",
        "ù": "u",
        "ú": "u",
        "û": "u",
        "ü": "u",
        "Ý": "Y",
        "ý": "y",
        "ÿ": "y",
        "Æ": "Ae",
        "æ": "ae",
        "Þ": "Th",
        "þ": "th",
        "ß": "ss",
        // Latin Extended-A block.
        "Ā": "A",
        "Ă": "A",
        "Ą": "A",
        "ā": "a",
        "ă": "a",
        "ą": "a",
        "Ć": "C",
        "Ĉ": "C",
        "Ċ": "C",
        "Č": "C",
        "ć": "c",
        "ĉ": "c",
        "ċ": "c",
        "č": "c",
        "Ď": "D",
        "Đ": "D",
        "ď": "d",
        "đ": "d",
        "Ē": "E",
        "Ĕ": "E",
        "Ė": "E",
        "Ę": "E",
        "Ě": "E",
        "ē": "e",
        "ĕ": "e",
        "ė": "e",
        "ę": "e",
        "ě": "e",
        "Ĝ": "G",
        "Ğ": "G",
        "Ġ": "G",
        "Ģ": "G",
        "ĝ": "g",
        "ğ": "g",
        "ġ": "g",
        "ģ": "g",
        "Ĥ": "H",
        "Ħ": "H",
        "ĥ": "h",
        "ħ": "h",
        "Ĩ": "I",
        "Ī": "I",
        "Ĭ": "I",
        "Į": "I",
        "İ": "I",
        "ĩ": "i",
        "ī": "i",
        "ĭ": "i",
        "į": "i",
        "ı": "i",
        "Ĵ": "J",
        "ĵ": "j",
        "Ķ": "K",
        "ķ": "k",
        "ĸ": "k",
        "Ĺ": "L",
        "Ļ": "L",
        "Ľ": "L",
        "Ŀ": "L",
        "Ł": "L",
        "ĺ": "l",
        "ļ": "l",
        "ľ": "l",
        "ŀ": "l",
        "ł": "l",
        "Ń": "N",
        "Ņ": "N",
        "Ň": "N",
        "Ŋ": "N",
        "ń": "n",
        "ņ": "n",
        "ň": "n",
        "ŋ": "n",
        "Ō": "O",
        "Ŏ": "O",
        "Ő": "O",
        "ō": "o",
        "ŏ": "o",
        "ő": "o",
        "Ŕ": "R",
        "Ŗ": "R",
        "Ř": "R",
        "ŕ": "r",
        "ŗ": "r",
        "ř": "r",
        "Ś": "S",
        "Ŝ": "S",
        "Ş": "S",
        "Š": "S",
        "ś": "s",
        "ŝ": "s",
        "ş": "s",
        "š": "s",
        "Ţ": "T",
        "Ť": "T",
        "Ŧ": "T",
        "ţ": "t",
        "ť": "t",
        "ŧ": "t",
        "Ũ": "U",
        "Ū": "U",
        "Ŭ": "U",
        "Ů": "U",
        "Ű": "U",
        "Ų": "U",
        "ũ": "u",
        "ū": "u",
        "ŭ": "u",
        "ů": "u",
        "ű": "u",
        "ų": "u",
        "Ŵ": "W",
        "ŵ": "w",
        "Ŷ": "Y",
        "ŷ": "y",
        "Ÿ": "Y",
        "Ź": "Z",
        "Ż": "Z",
        "Ž": "Z",
        "ź": "z",
        "ż": "z",
        "ž": "z",
        "Ĳ": "IJ",
        "ĳ": "ij",
        "Œ": "Oe",
        "œ": "oe",
        "ŉ": "'n",
        "ſ": "s"
      };
      var htmlEscapes = {
        "&": "&amp;",
        "<": "&lt;",
        ">": "&gt;",
        '"': "&quot;",
        "'": "&#39;"
      };
      var htmlUnescapes = {
        "&amp;": "&",
        "&lt;": "<",
        "&gt;": ">",
        "&quot;": '"',
        "&#39;": "'"
      };
      var stringEscapes = {
        "\\": "\\",
        "'": "'",
        "\n": "n",
        "\r": "r",
        "\u2028": "u2028",
        "\u2029": "u2029"
      };
      var freeParseFloat = parseFloat, freeParseInt = parseInt;
      var freeGlobal = typeof commonjsGlobal == "object" && commonjsGlobal && commonjsGlobal.Object === Object && commonjsGlobal;
      var freeSelf = typeof self == "object" && self && self.Object === Object && self;
      var root = freeGlobal || freeSelf || Function("return this")();
      var freeExports = exports2 && !exports2.nodeType && exports2;
      var freeModule = freeExports && true && module && !module.nodeType && module;
      var moduleExports = freeModule && freeModule.exports === freeExports;
      var freeProcess = moduleExports && freeGlobal.process;
      var nodeUtil = function() {
        try {
          var types = freeModule && freeModule.require && freeModule.require("util").types;
          if (types) {
            return types;
          }
          return freeProcess && freeProcess.binding && freeProcess.binding("util");
        } catch (e) {
        }
      }();
      var nodeIsArrayBuffer = nodeUtil && nodeUtil.isArrayBuffer, nodeIsDate = nodeUtil && nodeUtil.isDate, nodeIsMap = nodeUtil && nodeUtil.isMap, nodeIsRegExp = nodeUtil && nodeUtil.isRegExp, nodeIsSet = nodeUtil && nodeUtil.isSet, nodeIsTypedArray = nodeUtil && nodeUtil.isTypedArray;
      function apply(func, thisArg, args) {
        switch (args.length) {
          case 0:
            return func.call(thisArg);
          case 1:
            return func.call(thisArg, args[0]);
          case 2:
            return func.call(thisArg, args[0], args[1]);
          case 3:
            return func.call(thisArg, args[0], args[1], args[2]);
        }
        return func.apply(thisArg, args);
      }
      function arrayAggregator(array, setter, iteratee, accumulator) {
        var index = -1, length = array == null ? 0 : array.length;
        while (++index < length) {
          var value2 = array[index];
          setter(accumulator, value2, iteratee(value2), array);
        }
        return accumulator;
      }
      function arrayEach(array, iteratee) {
        var index = -1, length = array == null ? 0 : array.length;
        while (++index < length) {
          if (iteratee(array[index], index, array) === false) {
            break;
          }
        }
        return array;
      }
      function arrayEachRight(array, iteratee) {
        var length = array == null ? 0 : array.length;
        while (length--) {
          if (iteratee(array[length], length, array) === false) {
            break;
          }
        }
        return array;
      }
      function arrayEvery(array, predicate) {
        var index = -1, length = array == null ? 0 : array.length;
        while (++index < length) {
          if (!predicate(array[index], index, array)) {
            return false;
          }
        }
        return true;
      }
      function arrayFilter(array, predicate) {
        var index = -1, length = array == null ? 0 : array.length, resIndex = 0, result = [];
        while (++index < length) {
          var value2 = array[index];
          if (predicate(value2, index, array)) {
            result[resIndex++] = value2;
          }
        }
        return result;
      }
      function arrayIncludes(array, value2) {
        var length = array == null ? 0 : array.length;
        return !!length && baseIndexOf(array, value2, 0) > -1;
      }
      function arrayIncludesWith(array, value2, comparator) {
        var index = -1, length = array == null ? 0 : array.length;
        while (++index < length) {
          if (comparator(value2, array[index])) {
            return true;
          }
        }
        return false;
      }
      function arrayMap(array, iteratee) {
        var index = -1, length = array == null ? 0 : array.length, result = Array(length);
        while (++index < length) {
          result[index] = iteratee(array[index], index, array);
        }
        return result;
      }
      function arrayPush(array, values) {
        var index = -1, length = values.length, offset = array.length;
        while (++index < length) {
          array[offset + index] = values[index];
        }
        return array;
      }
      function arrayReduce(array, iteratee, accumulator, initAccum) {
        var index = -1, length = array == null ? 0 : array.length;
        if (initAccum && length) {
          accumulator = array[++index];
        }
        while (++index < length) {
          accumulator = iteratee(accumulator, array[index], index, array);
        }
        return accumulator;
      }
      function arrayReduceRight(array, iteratee, accumulator, initAccum) {
        var length = array == null ? 0 : array.length;
        if (initAccum && length) {
          accumulator = array[--length];
        }
        while (length--) {
          accumulator = iteratee(accumulator, array[length], length, array);
        }
        return accumulator;
      }
      function arraySome(array, predicate) {
        var index = -1, length = array == null ? 0 : array.length;
        while (++index < length) {
          if (predicate(array[index], index, array)) {
            return true;
          }
        }
        return false;
      }
      var asciiSize = baseProperty("length");
      function asciiToArray(string2) {
        return string2.split("");
      }
      function asciiWords(string2) {
        return string2.match(reAsciiWord) || [];
      }
      function baseFindKey(collection, predicate, eachFunc) {
        var result;
        eachFunc(collection, function(value2, key, collection2) {
          if (predicate(value2, key, collection2)) {
            result = key;
            return false;
          }
        });
        return result;
      }
      function baseFindIndex(array, predicate, fromIndex, fromRight) {
        var length = array.length, index = fromIndex + (fromRight ? 1 : -1);
        while (fromRight ? index-- : ++index < length) {
          if (predicate(array[index], index, array)) {
            return index;
          }
        }
        return -1;
      }
      function baseIndexOf(array, value2, fromIndex) {
        return value2 === value2 ? strictIndexOf(array, value2, fromIndex) : baseFindIndex(array, baseIsNaN, fromIndex);
      }
      function baseIndexOfWith(array, value2, fromIndex, comparator) {
        var index = fromIndex - 1, length = array.length;
        while (++index < length) {
          if (comparator(array[index], value2)) {
            return index;
          }
        }
        return -1;
      }
      function baseIsNaN(value2) {
        return value2 !== value2;
      }
      function baseMean(array, iteratee) {
        var length = array == null ? 0 : array.length;
        return length ? baseSum(array, iteratee) / length : NAN;
      }
      function baseProperty(key) {
        return function(object) {
          return object == null ? undefined$1 : object[key];
        };
      }
      function basePropertyOf(object) {
        return function(key) {
          return object == null ? undefined$1 : object[key];
        };
      }
      function baseReduce(collection, iteratee, accumulator, initAccum, eachFunc) {
        eachFunc(collection, function(value2, index, collection2) {
          accumulator = initAccum ? (initAccum = false, value2) : iteratee(accumulator, value2, index, collection2);
        });
        return accumulator;
      }
      function baseSortBy(array, comparer) {
        var length = array.length;
        array.sort(comparer);
        while (length--) {
          array[length] = array[length].value;
        }
        return array;
      }
      function baseSum(array, iteratee) {
        var result, index = -1, length = array.length;
        while (++index < length) {
          var current = iteratee(array[index]);
          if (current !== undefined$1) {
            result = result === undefined$1 ? current : result + current;
          }
        }
        return result;
      }
      function baseTimes(n, iteratee) {
        var index = -1, result = Array(n);
        while (++index < n) {
          result[index] = iteratee(index);
        }
        return result;
      }
      function baseToPairs(object, props) {
        return arrayMap(props, function(key) {
          return [key, object[key]];
        });
      }
      function baseTrim(string2) {
        return string2 ? string2.slice(0, trimmedEndIndex(string2) + 1).replace(reTrimStart, "") : string2;
      }
      function baseUnary(func) {
        return function(value2) {
          return func(value2);
        };
      }
      function baseValues(object, props) {
        return arrayMap(props, function(key) {
          return object[key];
        });
      }
      function cacheHas(cache, key) {
        return cache.has(key);
      }
      function charsStartIndex(strSymbols, chrSymbols) {
        var index = -1, length = strSymbols.length;
        while (++index < length && baseIndexOf(chrSymbols, strSymbols[index], 0) > -1) {
        }
        return index;
      }
      function charsEndIndex(strSymbols, chrSymbols) {
        var index = strSymbols.length;
        while (index-- && baseIndexOf(chrSymbols, strSymbols[index], 0) > -1) {
        }
        return index;
      }
      function countHolders(array, placeholder) {
        var length = array.length, result = 0;
        while (length--) {
          if (array[length] === placeholder) {
            ++result;
          }
        }
        return result;
      }
      var deburrLetter = basePropertyOf(deburredLetters);
      var escapeHtmlChar = basePropertyOf(htmlEscapes);
      function escapeStringChar(chr) {
        return "\\" + stringEscapes[chr];
      }
      function getValue(object, key) {
        return object == null ? undefined$1 : object[key];
      }
      function hasUnicode(string2) {
        return reHasUnicode.test(string2);
      }
      function hasUnicodeWord(string2) {
        return reHasUnicodeWord.test(string2);
      }
      function iteratorToArray(iterator) {
        var data2, result = [];
        while (!(data2 = iterator.next()).done) {
          result.push(data2.value);
        }
        return result;
      }
      function mapToArray(map2) {
        var index = -1, result = Array(map2.size);
        map2.forEach(function(value2, key) {
          result[++index] = [key, value2];
        });
        return result;
      }
      function overArg(func, transform) {
        return function(arg) {
          return func(transform(arg));
        };
      }
      function replaceHolders(array, placeholder) {
        var index = -1, length = array.length, resIndex = 0, result = [];
        while (++index < length) {
          var value2 = array[index];
          if (value2 === placeholder || value2 === PLACEHOLDER) {
            array[index] = PLACEHOLDER;
            result[resIndex++] = index;
          }
        }
        return result;
      }
      function setToArray(set) {
        var index = -1, result = Array(set.size);
        set.forEach(function(value2) {
          result[++index] = value2;
        });
        return result;
      }
      function setToPairs(set) {
        var index = -1, result = Array(set.size);
        set.forEach(function(value2) {
          result[++index] = [value2, value2];
        });
        return result;
      }
      function strictIndexOf(array, value2, fromIndex) {
        var index = fromIndex - 1, length = array.length;
        while (++index < length) {
          if (array[index] === value2) {
            return index;
          }
        }
        return -1;
      }
      function strictLastIndexOf(array, value2, fromIndex) {
        var index = fromIndex + 1;
        while (index--) {
          if (array[index] === value2) {
            return index;
          }
        }
        return index;
      }
      function stringSize(string2) {
        return hasUnicode(string2) ? unicodeSize(string2) : asciiSize(string2);
      }
      function stringToArray(string2) {
        return hasUnicode(string2) ? unicodeToArray(string2) : asciiToArray(string2);
      }
      function trimmedEndIndex(string2) {
        var index = string2.length;
        while (index-- && reWhitespace.test(string2.charAt(index))) {
        }
        return index;
      }
      var unescapeHtmlChar = basePropertyOf(htmlUnescapes);
      function unicodeSize(string2) {
        var result = reUnicode.lastIndex = 0;
        while (reUnicode.test(string2)) {
          ++result;
        }
        return result;
      }
      function unicodeToArray(string2) {
        return string2.match(reUnicode) || [];
      }
      function unicodeWords(string2) {
        return string2.match(reUnicodeWord) || [];
      }
      var runInContext = function runInContext2(context) {
        context = context == null ? root : _.defaults(root.Object(), context, _.pick(root, contextProps));
        var Array2 = context.Array, Date2 = context.Date, Error2 = context.Error, Function2 = context.Function, Math2 = context.Math, Object2 = context.Object, RegExp2 = context.RegExp, String2 = context.String, TypeError2 = context.TypeError;
        var arrayProto = Array2.prototype, funcProto = Function2.prototype, objectProto = Object2.prototype;
        var coreJsData = context["__core-js_shared__"];
        var funcToString = funcProto.toString;
        var hasOwnProperty = objectProto.hasOwnProperty;
        var idCounter = 0;
        var maskSrcKey = function() {
          var uid = /[^.]+$/.exec(coreJsData && coreJsData.keys && coreJsData.keys.IE_PROTO || "");
          return uid ? "Symbol(src)_1." + uid : "";
        }();
        var nativeObjectToString = objectProto.toString;
        var objectCtorString = funcToString.call(Object2);
        var oldDash = root._;
        var reIsNative = RegExp2(
          "^" + funcToString.call(hasOwnProperty).replace(reRegExpChar, "\\$&").replace(/hasOwnProperty|(function).*?(?=\\\()| for .+?(?=\\\])/g, "$1.*?") + "$"
        );
        var Buffer2 = moduleExports ? context.Buffer : undefined$1, Symbol2 = context.Symbol, Uint8Array2 = context.Uint8Array, allocUnsafe = Buffer2 ? Buffer2.allocUnsafe : undefined$1, getPrototype = overArg(Object2.getPrototypeOf, Object2), objectCreate = Object2.create, propertyIsEnumerable = objectProto.propertyIsEnumerable, splice = arrayProto.splice, spreadableSymbol = Symbol2 ? Symbol2.isConcatSpreadable : undefined$1, symIterator = Symbol2 ? Symbol2.iterator : undefined$1, symToStringTag = Symbol2 ? Symbol2.toStringTag : undefined$1;
        var defineProperty = function() {
          try {
            var func = getNative(Object2, "defineProperty");
            func({}, "", {});
            return func;
          } catch (e) {
          }
        }();
        var ctxClearTimeout = context.clearTimeout !== root.clearTimeout && context.clearTimeout, ctxNow = Date2 && Date2.now !== root.Date.now && Date2.now, ctxSetTimeout = context.setTimeout !== root.setTimeout && context.setTimeout;
        var nativeCeil = Math2.ceil, nativeFloor = Math2.floor, nativeGetSymbols = Object2.getOwnPropertySymbols, nativeIsBuffer = Buffer2 ? Buffer2.isBuffer : undefined$1, nativeIsFinite = context.isFinite, nativeJoin = arrayProto.join, nativeKeys = overArg(Object2.keys, Object2), nativeMax = Math2.max, nativeMin = Math2.min, nativeNow = Date2.now, nativeParseInt = context.parseInt, nativeRandom = Math2.random, nativeReverse = arrayProto.reverse;
        var DataView = getNative(context, "DataView"), Map = getNative(context, "Map"), Promise2 = getNative(context, "Promise"), Set2 = getNative(context, "Set"), WeakMap = getNative(context, "WeakMap"), nativeCreate = getNative(Object2, "create");
        var metaMap = WeakMap && new WeakMap();
        var realNames = {};
        var dataViewCtorString = toSource(DataView), mapCtorString = toSource(Map), promiseCtorString = toSource(Promise2), setCtorString = toSource(Set2), weakMapCtorString = toSource(WeakMap);
        var symbolProto = Symbol2 ? Symbol2.prototype : undefined$1, symbolValueOf = symbolProto ? symbolProto.valueOf : undefined$1, symbolToString = symbolProto ? symbolProto.toString : undefined$1;
        function lodash2(value2) {
          if (isObjectLike(value2) && !isArray(value2) && !(value2 instanceof LazyWrapper)) {
            if (value2 instanceof LodashWrapper) {
              return value2;
            }
            if (hasOwnProperty.call(value2, "__wrapped__")) {
              return wrapperClone(value2);
            }
          }
          return new LodashWrapper(value2);
        }
        var baseCreate = /* @__PURE__ */ function() {
          function object() {
          }
          return function(proto) {
            if (!isObject2(proto)) {
              return {};
            }
            if (objectCreate) {
              return objectCreate(proto);
            }
            object.prototype = proto;
            var result2 = new object();
            object.prototype = undefined$1;
            return result2;
          };
        }();
        function baseLodash() {
        }
        function LodashWrapper(value2, chainAll) {
          this.__wrapped__ = value2;
          this.__actions__ = [];
          this.__chain__ = !!chainAll;
          this.__index__ = 0;
          this.__values__ = undefined$1;
        }
        lodash2.templateSettings = {
          /**
           * Used to detect `data` property values to be HTML-escaped.
           *
           * @memberOf _.templateSettings
           * @type {RegExp}
           */
          "escape": reEscape,
          /**
           * Used to detect code to be evaluated.
           *
           * @memberOf _.templateSettings
           * @type {RegExp}
           */
          "evaluate": reEvaluate,
          /**
           * Used to detect `data` property values to inject.
           *
           * @memberOf _.templateSettings
           * @type {RegExp}
           */
          "interpolate": reInterpolate,
          /**
           * Used to reference the data object in the template text.
           *
           * @memberOf _.templateSettings
           * @type {string}
           */
          "variable": "",
          /**
           * Used to import variables into the compiled template.
           *
           * @memberOf _.templateSettings
           * @type {Object}
           */
          "imports": {
            /**
             * A reference to the `lodash` function.
             *
             * @memberOf _.templateSettings.imports
             * @type {Function}
             */
            "_": lodash2
          }
        };
        lodash2.prototype = baseLodash.prototype;
        lodash2.prototype.constructor = lodash2;
        LodashWrapper.prototype = baseCreate(baseLodash.prototype);
        LodashWrapper.prototype.constructor = LodashWrapper;
        function LazyWrapper(value2) {
          this.__wrapped__ = value2;
          this.__actions__ = [];
          this.__dir__ = 1;
          this.__filtered__ = false;
          this.__iteratees__ = [];
          this.__takeCount__ = MAX_ARRAY_LENGTH;
          this.__views__ = [];
        }
        function lazyClone() {
          var result2 = new LazyWrapper(this.__wrapped__);
          result2.__actions__ = copyArray(this.__actions__);
          result2.__dir__ = this.__dir__;
          result2.__filtered__ = this.__filtered__;
          result2.__iteratees__ = copyArray(this.__iteratees__);
          result2.__takeCount__ = this.__takeCount__;
          result2.__views__ = copyArray(this.__views__);
          return result2;
        }
        function lazyReverse() {
          if (this.__filtered__) {
            var result2 = new LazyWrapper(this);
            result2.__dir__ = -1;
            result2.__filtered__ = true;
          } else {
            result2 = this.clone();
            result2.__dir__ *= -1;
          }
          return result2;
        }
        function lazyValue() {
          var array = this.__wrapped__.value(), dir = this.__dir__, isArr = isArray(array), isRight = dir < 0, arrLength = isArr ? array.length : 0, view = getView(0, arrLength, this.__views__), start = view.start, end = view.end, length = end - start, index = isRight ? end : start - 1, iteratees = this.__iteratees__, iterLength = iteratees.length, resIndex = 0, takeCount = nativeMin(length, this.__takeCount__);
          if (!isArr || !isRight && arrLength == length && takeCount == length) {
            return baseWrapperValue(array, this.__actions__);
          }
          var result2 = [];
          outer:
            while (length-- && resIndex < takeCount) {
              index += dir;
              var iterIndex = -1, value2 = array[index];
              while (++iterIndex < iterLength) {
                var data2 = iteratees[iterIndex], iteratee2 = data2.iteratee, type = data2.type, computed = iteratee2(value2);
                if (type == LAZY_MAP_FLAG) {
                  value2 = computed;
                } else if (!computed) {
                  if (type == LAZY_FILTER_FLAG) {
                    continue outer;
                  } else {
                    break outer;
                  }
                }
              }
              result2[resIndex++] = value2;
            }
          return result2;
        }
        LazyWrapper.prototype = baseCreate(baseLodash.prototype);
        LazyWrapper.prototype.constructor = LazyWrapper;
        function Hash(entries) {
          var index = -1, length = entries == null ? 0 : entries.length;
          this.clear();
          while (++index < length) {
            var entry = entries[index];
            this.set(entry[0], entry[1]);
          }
        }
        function hashClear() {
          this.__data__ = nativeCreate ? nativeCreate(null) : {};
          this.size = 0;
        }
        function hashDelete(key) {
          var result2 = this.has(key) && delete this.__data__[key];
          this.size -= result2 ? 1 : 0;
          return result2;
        }
        function hashGet(key) {
          var data2 = this.__data__;
          if (nativeCreate) {
            var result2 = data2[key];
            return result2 === HASH_UNDEFINED ? undefined$1 : result2;
          }
          return hasOwnProperty.call(data2, key) ? data2[key] : undefined$1;
        }
        function hashHas(key) {
          var data2 = this.__data__;
          return nativeCreate ? data2[key] !== undefined$1 : hasOwnProperty.call(data2, key);
        }
        function hashSet(key, value2) {
          var data2 = this.__data__;
          this.size += this.has(key) ? 0 : 1;
          data2[key] = nativeCreate && value2 === undefined$1 ? HASH_UNDEFINED : value2;
          return this;
        }
        Hash.prototype.clear = hashClear;
        Hash.prototype["delete"] = hashDelete;
        Hash.prototype.get = hashGet;
        Hash.prototype.has = hashHas;
        Hash.prototype.set = hashSet;
        function ListCache(entries) {
          var index = -1, length = entries == null ? 0 : entries.length;
          this.clear();
          while (++index < length) {
            var entry = entries[index];
            this.set(entry[0], entry[1]);
          }
        }
        function listCacheClear() {
          this.__data__ = [];
          this.size = 0;
        }
        function listCacheDelete(key) {
          var data2 = this.__data__, index = assocIndexOf(data2, key);
          if (index < 0) {
            return false;
          }
          var lastIndex = data2.length - 1;
          if (index == lastIndex) {
            data2.pop();
          } else {
            splice.call(data2, index, 1);
          }
          --this.size;
          return true;
        }
        function listCacheGet(key) {
          var data2 = this.__data__, index = assocIndexOf(data2, key);
          return index < 0 ? undefined$1 : data2[index][1];
        }
        function listCacheHas(key) {
          return assocIndexOf(this.__data__, key) > -1;
        }
        function listCacheSet(key, value2) {
          var data2 = this.__data__, index = assocIndexOf(data2, key);
          if (index < 0) {
            ++this.size;
            data2.push([key, value2]);
          } else {
            data2[index][1] = value2;
          }
          return this;
        }
        ListCache.prototype.clear = listCacheClear;
        ListCache.prototype["delete"] = listCacheDelete;
        ListCache.prototype.get = listCacheGet;
        ListCache.prototype.has = listCacheHas;
        ListCache.prototype.set = listCacheSet;
        function MapCache(entries) {
          var index = -1, length = entries == null ? 0 : entries.length;
          this.clear();
          while (++index < length) {
            var entry = entries[index];
            this.set(entry[0], entry[1]);
          }
        }
        function mapCacheClear() {
          this.size = 0;
          this.__data__ = {
            "hash": new Hash(),
            "map": new (Map || ListCache)(),
            "string": new Hash()
          };
        }
        function mapCacheDelete(key) {
          var result2 = getMapData(this, key)["delete"](key);
          this.size -= result2 ? 1 : 0;
          return result2;
        }
        function mapCacheGet(key) {
          return getMapData(this, key).get(key);
        }
        function mapCacheHas(key) {
          return getMapData(this, key).has(key);
        }
        function mapCacheSet(key, value2) {
          var data2 = getMapData(this, key), size2 = data2.size;
          data2.set(key, value2);
          this.size += data2.size == size2 ? 0 : 1;
          return this;
        }
        MapCache.prototype.clear = mapCacheClear;
        MapCache.prototype["delete"] = mapCacheDelete;
        MapCache.prototype.get = mapCacheGet;
        MapCache.prototype.has = mapCacheHas;
        MapCache.prototype.set = mapCacheSet;
        function SetCache(values2) {
          var index = -1, length = values2 == null ? 0 : values2.length;
          this.__data__ = new MapCache();
          while (++index < length) {
            this.add(values2[index]);
          }
        }
        function setCacheAdd(value2) {
          this.__data__.set(value2, HASH_UNDEFINED);
          return this;
        }
        function setCacheHas(value2) {
          return this.__data__.has(value2);
        }
        SetCache.prototype.add = SetCache.prototype.push = setCacheAdd;
        SetCache.prototype.has = setCacheHas;
        function Stack(entries) {
          var data2 = this.__data__ = new ListCache(entries);
          this.size = data2.size;
        }
        function stackClear() {
          this.__data__ = new ListCache();
          this.size = 0;
        }
        function stackDelete(key) {
          var data2 = this.__data__, result2 = data2["delete"](key);
          this.size = data2.size;
          return result2;
        }
        function stackGet(key) {
          return this.__data__.get(key);
        }
        function stackHas(key) {
          return this.__data__.has(key);
        }
        function stackSet(key, value2) {
          var data2 = this.__data__;
          if (data2 instanceof ListCache) {
            var pairs = data2.__data__;
            if (!Map || pairs.length < LARGE_ARRAY_SIZE - 1) {
              pairs.push([key, value2]);
              this.size = ++data2.size;
              return this;
            }
            data2 = this.__data__ = new MapCache(pairs);
          }
          data2.set(key, value2);
          this.size = data2.size;
          return this;
        }
        Stack.prototype.clear = stackClear;
        Stack.prototype["delete"] = stackDelete;
        Stack.prototype.get = stackGet;
        Stack.prototype.has = stackHas;
        Stack.prototype.set = stackSet;
        function arrayLikeKeys(value2, inherited) {
          var isArr = isArray(value2), isArg = !isArr && isArguments(value2), isBuff = !isArr && !isArg && isBuffer(value2), isType = !isArr && !isArg && !isBuff && isTypedArray(value2), skipIndexes = isArr || isArg || isBuff || isType, result2 = skipIndexes ? baseTimes(value2.length, String2) : [], length = result2.length;
          for (var key in value2) {
            if ((inherited || hasOwnProperty.call(value2, key)) && !(skipIndexes && // Safari 9 has enumerable `arguments.length` in strict mode.
            (key == "length" || // Node.js 0.10 has enumerable non-index properties on buffers.
            isBuff && (key == "offset" || key == "parent") || // PhantomJS 2 has enumerable non-index properties on typed arrays.
            isType && (key == "buffer" || key == "byteLength" || key == "byteOffset") || // Skip index properties.
            isIndex(key, length)))) {
              result2.push(key);
            }
          }
          return result2;
        }
        function arraySample(array) {
          var length = array.length;
          return length ? array[baseRandom(0, length - 1)] : undefined$1;
        }
        function arraySampleSize(array, n) {
          return shuffleSelf(copyArray(array), baseClamp(n, 0, array.length));
        }
        function arrayShuffle(array) {
          return shuffleSelf(copyArray(array));
        }
        function assignMergeValue(object, key, value2) {
          if (value2 !== undefined$1 && !eq(object[key], value2) || value2 === undefined$1 && !(key in object)) {
            baseAssignValue(object, key, value2);
          }
        }
        function assignValue(object, key, value2) {
          var objValue = object[key];
          if (!(hasOwnProperty.call(object, key) && eq(objValue, value2)) || value2 === undefined$1 && !(key in object)) {
            baseAssignValue(object, key, value2);
          }
        }
        function assocIndexOf(array, key) {
          var length = array.length;
          while (length--) {
            if (eq(array[length][0], key)) {
              return length;
            }
          }
          return -1;
        }
        function baseAggregator(collection, setter, iteratee2, accumulator) {
          baseEach(collection, function(value2, key, collection2) {
            setter(accumulator, value2, iteratee2(value2), collection2);
          });
          return accumulator;
        }
        function baseAssign(object, source) {
          return object && copyObject(source, keys(source), object);
        }
        function baseAssignIn(object, source) {
          return object && copyObject(source, keysIn(source), object);
        }
        function baseAssignValue(object, key, value2) {
          if (key == "__proto__" && defineProperty) {
            defineProperty(object, key, {
              "configurable": true,
              "enumerable": true,
              "value": value2,
              "writable": true
            });
          } else {
            object[key] = value2;
          }
        }
        function baseAt(object, paths) {
          var index = -1, length = paths.length, result2 = Array2(length), skip = object == null;
          while (++index < length) {
            result2[index] = skip ? undefined$1 : get(object, paths[index]);
          }
          return result2;
        }
        function baseClamp(number, lower, upper) {
          if (number === number) {
            if (upper !== undefined$1) {
              number = number <= upper ? number : upper;
            }
            if (lower !== undefined$1) {
              number = number >= lower ? number : lower;
            }
          }
          return number;
        }
        function baseClone(value2, bitmask, customizer, key, object, stack) {
          var result2, isDeep = bitmask & CLONE_DEEP_FLAG, isFlat = bitmask & CLONE_FLAT_FLAG, isFull = bitmask & CLONE_SYMBOLS_FLAG;
          if (customizer) {
            result2 = object ? customizer(value2, key, object, stack) : customizer(value2);
          }
          if (result2 !== undefined$1) {
            return result2;
          }
          if (!isObject2(value2)) {
            return value2;
          }
          var isArr = isArray(value2);
          if (isArr) {
            result2 = initCloneArray(value2);
            if (!isDeep) {
              return copyArray(value2, result2);
            }
          } else {
            var tag = getTag(value2), isFunc = tag == funcTag || tag == genTag;
            if (isBuffer(value2)) {
              return cloneBuffer(value2, isDeep);
            }
            if (tag == objectTag || tag == argsTag || isFunc && !object) {
              result2 = isFlat || isFunc ? {} : initCloneObject(value2);
              if (!isDeep) {
                return isFlat ? copySymbolsIn(value2, baseAssignIn(result2, value2)) : copySymbols(value2, baseAssign(result2, value2));
              }
            } else {
              if (!cloneableTags[tag]) {
                return object ? value2 : {};
              }
              result2 = initCloneByTag(value2, tag, isDeep);
            }
          }
          stack || (stack = new Stack());
          var stacked = stack.get(value2);
          if (stacked) {
            return stacked;
          }
          stack.set(value2, result2);
          if (isSet(value2)) {
            value2.forEach(function(subValue) {
              result2.add(baseClone(subValue, bitmask, customizer, subValue, value2, stack));
            });
          } else if (isMap(value2)) {
            value2.forEach(function(subValue, key2) {
              result2.set(key2, baseClone(subValue, bitmask, customizer, key2, value2, stack));
            });
          }
          var keysFunc = isFull ? isFlat ? getAllKeysIn : getAllKeys : isFlat ? keysIn : keys;
          var props = isArr ? undefined$1 : keysFunc(value2);
          arrayEach(props || value2, function(subValue, key2) {
            if (props) {
              key2 = subValue;
              subValue = value2[key2];
            }
            assignValue(result2, key2, baseClone(subValue, bitmask, customizer, key2, value2, stack));
          });
          return result2;
        }
        function baseConforms(source) {
          var props = keys(source);
          return function(object) {
            return baseConformsTo(object, source, props);
          };
        }
        function baseConformsTo(object, source, props) {
          var length = props.length;
          if (object == null) {
            return !length;
          }
          object = Object2(object);
          while (length--) {
            var key = props[length], predicate = source[key], value2 = object[key];
            if (value2 === undefined$1 && !(key in object) || !predicate(value2)) {
              return false;
            }
          }
          return true;
        }
        function baseDelay(func, wait, args) {
          if (typeof func != "function") {
            throw new TypeError2(FUNC_ERROR_TEXT);
          }
          return setTimeout(function() {
            func.apply(undefined$1, args);
          }, wait);
        }
        function baseDifference(array, values2, iteratee2, comparator) {
          var index = -1, includes2 = arrayIncludes, isCommon = true, length = array.length, result2 = [], valuesLength = values2.length;
          if (!length) {
            return result2;
          }
          if (iteratee2) {
            values2 = arrayMap(values2, baseUnary(iteratee2));
          }
          if (comparator) {
            includes2 = arrayIncludesWith;
            isCommon = false;
          } else if (values2.length >= LARGE_ARRAY_SIZE) {
            includes2 = cacheHas;
            isCommon = false;
            values2 = new SetCache(values2);
          }
          outer:
            while (++index < length) {
              var value2 = array[index], computed = iteratee2 == null ? value2 : iteratee2(value2);
              value2 = comparator || value2 !== 0 ? value2 : 0;
              if (isCommon && computed === computed) {
                var valuesIndex = valuesLength;
                while (valuesIndex--) {
                  if (values2[valuesIndex] === computed) {
                    continue outer;
                  }
                }
                result2.push(value2);
              } else if (!includes2(values2, computed, comparator)) {
                result2.push(value2);
              }
            }
          return result2;
        }
        var baseEach = createBaseEach(baseForOwn);
        var baseEachRight = createBaseEach(baseForOwnRight, true);
        function baseEvery(collection, predicate) {
          var result2 = true;
          baseEach(collection, function(value2, index, collection2) {
            result2 = !!predicate(value2, index, collection2);
            return result2;
          });
          return result2;
        }
        function baseExtremum(array, iteratee2, comparator) {
          var index = -1, length = array.length;
          while (++index < length) {
            var value2 = array[index], current = iteratee2(value2);
            if (current != null && (computed === undefined$1 ? current === current && !isSymbol(current) : comparator(current, computed))) {
              var computed = current, result2 = value2;
            }
          }
          return result2;
        }
        function baseFill(array, value2, start, end) {
          var length = array.length;
          start = toInteger(start);
          if (start < 0) {
            start = -start > length ? 0 : length + start;
          }
          end = end === undefined$1 || end > length ? length : toInteger(end);
          if (end < 0) {
            end += length;
          }
          end = start > end ? 0 : toLength(end);
          while (start < end) {
            array[start++] = value2;
          }
          return array;
        }
        function baseFilter(collection, predicate) {
          var result2 = [];
          baseEach(collection, function(value2, index, collection2) {
            if (predicate(value2, index, collection2)) {
              result2.push(value2);
            }
          });
          return result2;
        }
        function baseFlatten(array, depth, predicate, isStrict, result2) {
          var index = -1, length = array.length;
          predicate || (predicate = isFlattenable);
          result2 || (result2 = []);
          while (++index < length) {
            var value2 = array[index];
            if (depth > 0 && predicate(value2)) {
              if (depth > 1) {
                baseFlatten(value2, depth - 1, predicate, isStrict, result2);
              } else {
                arrayPush(result2, value2);
              }
            } else if (!isStrict) {
              result2[result2.length] = value2;
            }
          }
          return result2;
        }
        var baseFor = createBaseFor();
        var baseForRight = createBaseFor(true);
        function baseForOwn(object, iteratee2) {
          return object && baseFor(object, iteratee2, keys);
        }
        function baseForOwnRight(object, iteratee2) {
          return object && baseForRight(object, iteratee2, keys);
        }
        function baseFunctions(object, props) {
          return arrayFilter(props, function(key) {
            return isFunction(object[key]);
          });
        }
        function baseGet(object, path) {
          path = castPath(path, object);
          var index = 0, length = path.length;
          while (object != null && index < length) {
            object = object[toKey(path[index++])];
          }
          return index && index == length ? object : undefined$1;
        }
        function baseGetAllKeys(object, keysFunc, symbolsFunc) {
          var result2 = keysFunc(object);
          return isArray(object) ? result2 : arrayPush(result2, symbolsFunc(object));
        }
        function baseGetTag(value2) {
          if (value2 == null) {
            return value2 === undefined$1 ? undefinedTag : nullTag;
          }
          return symToStringTag && symToStringTag in Object2(value2) ? getRawTag(value2) : objectToString(value2);
        }
        function baseGt(value2, other) {
          return value2 > other;
        }
        function baseHas(object, key) {
          return object != null && hasOwnProperty.call(object, key);
        }
        function baseHasIn(object, key) {
          return object != null && key in Object2(object);
        }
        function baseInRange(number, start, end) {
          return number >= nativeMin(start, end) && number < nativeMax(start, end);
        }
        function baseIntersection(arrays, iteratee2, comparator) {
          var includes2 = comparator ? arrayIncludesWith : arrayIncludes, length = arrays[0].length, othLength = arrays.length, othIndex = othLength, caches = Array2(othLength), maxLength = Infinity, result2 = [];
          while (othIndex--) {
            var array = arrays[othIndex];
            if (othIndex && iteratee2) {
              array = arrayMap(array, baseUnary(iteratee2));
            }
            maxLength = nativeMin(array.length, maxLength);
            caches[othIndex] = !comparator && (iteratee2 || length >= 120 && array.length >= 120) ? new SetCache(othIndex && array) : undefined$1;
          }
          array = arrays[0];
          var index = -1, seen = caches[0];
          outer:
            while (++index < length && result2.length < maxLength) {
              var value2 = array[index], computed = iteratee2 ? iteratee2(value2) : value2;
              value2 = comparator || value2 !== 0 ? value2 : 0;
              if (!(seen ? cacheHas(seen, computed) : includes2(result2, computed, comparator))) {
                othIndex = othLength;
                while (--othIndex) {
                  var cache = caches[othIndex];
                  if (!(cache ? cacheHas(cache, computed) : includes2(arrays[othIndex], computed, comparator))) {
                    continue outer;
                  }
                }
                if (seen) {
                  seen.push(computed);
                }
                result2.push(value2);
              }
            }
          return result2;
        }
        function baseInverter(object, setter, iteratee2, accumulator) {
          baseForOwn(object, function(value2, key, object2) {
            setter(accumulator, iteratee2(value2), key, object2);
          });
          return accumulator;
        }
        function baseInvoke(object, path, args) {
          path = castPath(path, object);
          object = parent(object, path);
          var func = object == null ? object : object[toKey(last(path))];
          return func == null ? undefined$1 : apply(func, object, args);
        }
        function baseIsArguments(value2) {
          return isObjectLike(value2) && baseGetTag(value2) == argsTag;
        }
        function baseIsArrayBuffer(value2) {
          return isObjectLike(value2) && baseGetTag(value2) == arrayBufferTag;
        }
        function baseIsDate(value2) {
          return isObjectLike(value2) && baseGetTag(value2) == dateTag;
        }
        function baseIsEqual(value2, other, bitmask, customizer, stack) {
          if (value2 === other) {
            return true;
          }
          if (value2 == null || other == null || !isObjectLike(value2) && !isObjectLike(other)) {
            return value2 !== value2 && other !== other;
          }
          return baseIsEqualDeep(value2, other, bitmask, customizer, baseIsEqual, stack);
        }
        function baseIsEqualDeep(object, other, bitmask, customizer, equalFunc, stack) {
          var objIsArr = isArray(object), othIsArr = isArray(other), objTag = objIsArr ? arrayTag : getTag(object), othTag = othIsArr ? arrayTag : getTag(other);
          objTag = objTag == argsTag ? objectTag : objTag;
          othTag = othTag == argsTag ? objectTag : othTag;
          var objIsObj = objTag == objectTag, othIsObj = othTag == objectTag, isSameTag = objTag == othTag;
          if (isSameTag && isBuffer(object)) {
            if (!isBuffer(other)) {
              return false;
            }
            objIsArr = true;
            objIsObj = false;
          }
          if (isSameTag && !objIsObj) {
            stack || (stack = new Stack());
            return objIsArr || isTypedArray(object) ? equalArrays(object, other, bitmask, customizer, equalFunc, stack) : equalByTag(object, other, objTag, bitmask, customizer, equalFunc, stack);
          }
          if (!(bitmask & COMPARE_PARTIAL_FLAG)) {
            var objIsWrapped = objIsObj && hasOwnProperty.call(object, "__wrapped__"), othIsWrapped = othIsObj && hasOwnProperty.call(other, "__wrapped__");
            if (objIsWrapped || othIsWrapped) {
              var objUnwrapped = objIsWrapped ? object.value() : object, othUnwrapped = othIsWrapped ? other.value() : other;
              stack || (stack = new Stack());
              return equalFunc(objUnwrapped, othUnwrapped, bitmask, customizer, stack);
            }
          }
          if (!isSameTag) {
            return false;
          }
          stack || (stack = new Stack());
          return equalObjects(object, other, bitmask, customizer, equalFunc, stack);
        }
        function baseIsMap(value2) {
          return isObjectLike(value2) && getTag(value2) == mapTag;
        }
        function baseIsMatch(object, source, matchData, customizer) {
          var index = matchData.length, length = index, noCustomizer = !customizer;
          if (object == null) {
            return !length;
          }
          object = Object2(object);
          while (index--) {
            var data2 = matchData[index];
            if (noCustomizer && data2[2] ? data2[1] !== object[data2[0]] : !(data2[0] in object)) {
              return false;
            }
          }
          while (++index < length) {
            data2 = matchData[index];
            var key = data2[0], objValue = object[key], srcValue = data2[1];
            if (noCustomizer && data2[2]) {
              if (objValue === undefined$1 && !(key in object)) {
                return false;
              }
            } else {
              var stack = new Stack();
              if (customizer) {
                var result2 = customizer(objValue, srcValue, key, object, source, stack);
              }
              if (!(result2 === undefined$1 ? baseIsEqual(srcValue, objValue, COMPARE_PARTIAL_FLAG | COMPARE_UNORDERED_FLAG, customizer, stack) : result2)) {
                return false;
              }
            }
          }
          return true;
        }
        function baseIsNative(value2) {
          if (!isObject2(value2) || isMasked(value2)) {
            return false;
          }
          var pattern = isFunction(value2) ? reIsNative : reIsHostCtor;
          return pattern.test(toSource(value2));
        }
        function baseIsRegExp(value2) {
          return isObjectLike(value2) && baseGetTag(value2) == regexpTag;
        }
        function baseIsSet(value2) {
          return isObjectLike(value2) && getTag(value2) == setTag;
        }
        function baseIsTypedArray(value2) {
          return isObjectLike(value2) && isLength(value2.length) && !!typedArrayTags[baseGetTag(value2)];
        }
        function baseIteratee(value2) {
          if (typeof value2 == "function") {
            return value2;
          }
          if (value2 == null) {
            return identity;
          }
          if (typeof value2 == "object") {
            return isArray(value2) ? baseMatchesProperty(value2[0], value2[1]) : baseMatches(value2);
          }
          return property(value2);
        }
        function baseKeys(object) {
          if (!isPrototype(object)) {
            return nativeKeys(object);
          }
          var result2 = [];
          for (var key in Object2(object)) {
            if (hasOwnProperty.call(object, key) && key != "constructor") {
              result2.push(key);
            }
          }
          return result2;
        }
        function baseKeysIn(object) {
          if (!isObject2(object)) {
            return nativeKeysIn(object);
          }
          var isProto = isPrototype(object), result2 = [];
          for (var key in object) {
            if (!(key == "constructor" && (isProto || !hasOwnProperty.call(object, key)))) {
              result2.push(key);
            }
          }
          return result2;
        }
        function baseLt(value2, other) {
          return value2 < other;
        }
        function baseMap(collection, iteratee2) {
          var index = -1, result2 = isArrayLike(collection) ? Array2(collection.length) : [];
          baseEach(collection, function(value2, key, collection2) {
            result2[++index] = iteratee2(value2, key, collection2);
          });
          return result2;
        }
        function baseMatches(source) {
          var matchData = getMatchData(source);
          if (matchData.length == 1 && matchData[0][2]) {
            return matchesStrictComparable(matchData[0][0], matchData[0][1]);
          }
          return function(object) {
            return object === source || baseIsMatch(object, source, matchData);
          };
        }
        function baseMatchesProperty(path, srcValue) {
          if (isKey(path) && isStrictComparable(srcValue)) {
            return matchesStrictComparable(toKey(path), srcValue);
          }
          return function(object) {
            var objValue = get(object, path);
            return objValue === undefined$1 && objValue === srcValue ? hasIn(object, path) : baseIsEqual(srcValue, objValue, COMPARE_PARTIAL_FLAG | COMPARE_UNORDERED_FLAG);
          };
        }
        function baseMerge(object, source, srcIndex, customizer, stack) {
          if (object === source) {
            return;
          }
          baseFor(source, function(srcValue, key) {
            stack || (stack = new Stack());
            if (isObject2(srcValue)) {
              baseMergeDeep(object, source, key, srcIndex, baseMerge, customizer, stack);
            } else {
              var newValue = customizer ? customizer(safeGet(object, key), srcValue, key + "", object, source, stack) : undefined$1;
              if (newValue === undefined$1) {
                newValue = srcValue;
              }
              assignMergeValue(object, key, newValue);
            }
          }, keysIn);
        }
        function baseMergeDeep(object, source, key, srcIndex, mergeFunc, customizer, stack) {
          var objValue = safeGet(object, key), srcValue = safeGet(source, key), stacked = stack.get(srcValue);
          if (stacked) {
            assignMergeValue(object, key, stacked);
            return;
          }
          var newValue = customizer ? customizer(objValue, srcValue, key + "", object, source, stack) : undefined$1;
          var isCommon = newValue === undefined$1;
          if (isCommon) {
            var isArr = isArray(srcValue), isBuff = !isArr && isBuffer(srcValue), isTyped = !isArr && !isBuff && isTypedArray(srcValue);
            newValue = srcValue;
            if (isArr || isBuff || isTyped) {
              if (isArray(objValue)) {
                newValue = objValue;
              } else if (isArrayLikeObject(objValue)) {
                newValue = copyArray(objValue);
              } else if (isBuff) {
                isCommon = false;
                newValue = cloneBuffer(srcValue, true);
              } else if (isTyped) {
                isCommon = false;
                newValue = cloneTypedArray(srcValue, true);
              } else {
                newValue = [];
              }
            } else if (isPlainObject(srcValue) || isArguments(srcValue)) {
              newValue = objValue;
              if (isArguments(objValue)) {
                newValue = toPlainObject(objValue);
              } else if (!isObject2(objValue) || isFunction(objValue)) {
                newValue = initCloneObject(srcValue);
              }
            } else {
              isCommon = false;
            }
          }
          if (isCommon) {
            stack.set(srcValue, newValue);
            mergeFunc(newValue, srcValue, srcIndex, customizer, stack);
            stack["delete"](srcValue);
          }
          assignMergeValue(object, key, newValue);
        }
        function baseNth(array, n) {
          var length = array.length;
          if (!length) {
            return;
          }
          n += n < 0 ? length : 0;
          return isIndex(n, length) ? array[n] : undefined$1;
        }
        function baseOrderBy(collection, iteratees, orders) {
          if (iteratees.length) {
            iteratees = arrayMap(iteratees, function(iteratee2) {
              if (isArray(iteratee2)) {
                return function(value2) {
                  return baseGet(value2, iteratee2.length === 1 ? iteratee2[0] : iteratee2);
                };
              }
              return iteratee2;
            });
          } else {
            iteratees = [identity];
          }
          var index = -1;
          iteratees = arrayMap(iteratees, baseUnary(getIteratee()));
          var result2 = baseMap(collection, function(value2, key, collection2) {
            var criteria = arrayMap(iteratees, function(iteratee2) {
              return iteratee2(value2);
            });
            return { "criteria": criteria, "index": ++index, "value": value2 };
          });
          return baseSortBy(result2, function(object, other) {
            return compareMultiple(object, other, orders);
          });
        }
        function basePick(object, paths) {
          return basePickBy(object, paths, function(value2, path) {
            return hasIn(object, path);
          });
        }
        function basePickBy(object, paths, predicate) {
          var index = -1, length = paths.length, result2 = {};
          while (++index < length) {
            var path = paths[index], value2 = baseGet(object, path);
            if (predicate(value2, path)) {
              baseSet(result2, castPath(path, object), value2);
            }
          }
          return result2;
        }
        function basePropertyDeep(path) {
          return function(object) {
            return baseGet(object, path);
          };
        }
        function basePullAll(array, values2, iteratee2, comparator) {
          var indexOf2 = comparator ? baseIndexOfWith : baseIndexOf, index = -1, length = values2.length, seen = array;
          if (array === values2) {
            values2 = copyArray(values2);
          }
          if (iteratee2) {
            seen = arrayMap(array, baseUnary(iteratee2));
          }
          while (++index < length) {
            var fromIndex = 0, value2 = values2[index], computed = iteratee2 ? iteratee2(value2) : value2;
            while ((fromIndex = indexOf2(seen, computed, fromIndex, comparator)) > -1) {
              if (seen !== array) {
                splice.call(seen, fromIndex, 1);
              }
              splice.call(array, fromIndex, 1);
            }
          }
          return array;
        }
        function basePullAt(array, indexes) {
          var length = array ? indexes.length : 0, lastIndex = length - 1;
          while (length--) {
            var index = indexes[length];
            if (length == lastIndex || index !== previous) {
              var previous = index;
              if (isIndex(index)) {
                splice.call(array, index, 1);
              } else {
                baseUnset(array, index);
              }
            }
          }
          return array;
        }
        function baseRandom(lower, upper) {
          return lower + nativeFloor(nativeRandom() * (upper - lower + 1));
        }
        function baseRange(start, end, step, fromRight) {
          var index = -1, length = nativeMax(nativeCeil((end - start) / (step || 1)), 0), result2 = Array2(length);
          while (length--) {
            result2[fromRight ? length : ++index] = start;
            start += step;
          }
          return result2;
        }
        function baseRepeat(string2, n) {
          var result2 = "";
          if (!string2 || n < 1 || n > MAX_SAFE_INTEGER) {
            return result2;
          }
          do {
            if (n % 2) {
              result2 += string2;
            }
            n = nativeFloor(n / 2);
            if (n) {
              string2 += string2;
            }
          } while (n);
          return result2;
        }
        function baseRest(func, start) {
          return setToString(overRest(func, start, identity), func + "");
        }
        function baseSample(collection) {
          return arraySample(values(collection));
        }
        function baseSampleSize(collection, n) {
          var array = values(collection);
          return shuffleSelf(array, baseClamp(n, 0, array.length));
        }
        function baseSet(object, path, value2, customizer) {
          if (!isObject2(object)) {
            return object;
          }
          path = castPath(path, object);
          var index = -1, length = path.length, lastIndex = length - 1, nested = object;
          while (nested != null && ++index < length) {
            var key = toKey(path[index]), newValue = value2;
            if (key === "__proto__" || key === "constructor" || key === "prototype") {
              return object;
            }
            if (index != lastIndex) {
              var objValue = nested[key];
              newValue = customizer ? customizer(objValue, key, nested) : undefined$1;
              if (newValue === undefined$1) {
                newValue = isObject2(objValue) ? objValue : isIndex(path[index + 1]) ? [] : {};
              }
            }
            assignValue(nested, key, newValue);
            nested = nested[key];
          }
          return object;
        }
        var baseSetData = !metaMap ? identity : function(func, data2) {
          metaMap.set(func, data2);
          return func;
        };
        var baseSetToString = !defineProperty ? identity : function(func, string2) {
          return defineProperty(func, "toString", {
            "configurable": true,
            "enumerable": false,
            "value": constant(string2),
            "writable": true
          });
        };
        function baseShuffle(collection) {
          return shuffleSelf(values(collection));
        }
        function baseSlice(array, start, end) {
          var index = -1, length = array.length;
          if (start < 0) {
            start = -start > length ? 0 : length + start;
          }
          end = end > length ? length : end;
          if (end < 0) {
            end += length;
          }
          length = start > end ? 0 : end - start >>> 0;
          start >>>= 0;
          var result2 = Array2(length);
          while (++index < length) {
            result2[index] = array[index + start];
          }
          return result2;
        }
        function baseSome(collection, predicate) {
          var result2;
          baseEach(collection, function(value2, index, collection2) {
            result2 = predicate(value2, index, collection2);
            return !result2;
          });
          return !!result2;
        }
        function baseSortedIndex(array, value2, retHighest) {
          var low = 0, high = array == null ? low : array.length;
          if (typeof value2 == "number" && value2 === value2 && high <= HALF_MAX_ARRAY_LENGTH) {
            while (low < high) {
              var mid = low + high >>> 1, computed = array[mid];
              if (computed !== null && !isSymbol(computed) && (retHighest ? computed <= value2 : computed < value2)) {
                low = mid + 1;
              } else {
                high = mid;
              }
            }
            return high;
          }
          return baseSortedIndexBy(array, value2, identity, retHighest);
        }
        function baseSortedIndexBy(array, value2, iteratee2, retHighest) {
          var low = 0, high = array == null ? 0 : array.length;
          if (high === 0) {
            return 0;
          }
          value2 = iteratee2(value2);
          var valIsNaN = value2 !== value2, valIsNull = value2 === null, valIsSymbol = isSymbol(value2), valIsUndefined = value2 === undefined$1;
          while (low < high) {
            var mid = nativeFloor((low + high) / 2), computed = iteratee2(array[mid]), othIsDefined = computed !== undefined$1, othIsNull = computed === null, othIsReflexive = computed === computed, othIsSymbol = isSymbol(computed);
            if (valIsNaN) {
              var setLow = retHighest || othIsReflexive;
            } else if (valIsUndefined) {
              setLow = othIsReflexive && (retHighest || othIsDefined);
            } else if (valIsNull) {
              setLow = othIsReflexive && othIsDefined && (retHighest || !othIsNull);
            } else if (valIsSymbol) {
              setLow = othIsReflexive && othIsDefined && !othIsNull && (retHighest || !othIsSymbol);
            } else if (othIsNull || othIsSymbol) {
              setLow = false;
            } else {
              setLow = retHighest ? computed <= value2 : computed < value2;
            }
            if (setLow) {
              low = mid + 1;
            } else {
              high = mid;
            }
          }
          return nativeMin(high, MAX_ARRAY_INDEX);
        }
        function baseSortedUniq(array, iteratee2) {
          var index = -1, length = array.length, resIndex = 0, result2 = [];
          while (++index < length) {
            var value2 = array[index], computed = iteratee2 ? iteratee2(value2) : value2;
            if (!index || !eq(computed, seen)) {
              var seen = computed;
              result2[resIndex++] = value2 === 0 ? 0 : value2;
            }
          }
          return result2;
        }
        function baseToNumber(value2) {
          if (typeof value2 == "number") {
            return value2;
          }
          if (isSymbol(value2)) {
            return NAN;
          }
          return +value2;
        }
        function baseToString(value2) {
          if (typeof value2 == "string") {
            return value2;
          }
          if (isArray(value2)) {
            return arrayMap(value2, baseToString) + "";
          }
          if (isSymbol(value2)) {
            return symbolToString ? symbolToString.call(value2) : "";
          }
          var result2 = value2 + "";
          return result2 == "0" && 1 / value2 == -INFINITY ? "-0" : result2;
        }
        function baseUniq(array, iteratee2, comparator) {
          var index = -1, includes2 = arrayIncludes, length = array.length, isCommon = true, result2 = [], seen = result2;
          if (comparator) {
            isCommon = false;
            includes2 = arrayIncludesWith;
          } else if (length >= LARGE_ARRAY_SIZE) {
            var set2 = iteratee2 ? null : createSet(array);
            if (set2) {
              return setToArray(set2);
            }
            isCommon = false;
            includes2 = cacheHas;
            seen = new SetCache();
          } else {
            seen = iteratee2 ? [] : result2;
          }
          outer:
            while (++index < length) {
              var value2 = array[index], computed = iteratee2 ? iteratee2(value2) : value2;
              value2 = comparator || value2 !== 0 ? value2 : 0;
              if (isCommon && computed === computed) {
                var seenIndex = seen.length;
                while (seenIndex--) {
                  if (seen[seenIndex] === computed) {
                    continue outer;
                  }
                }
                if (iteratee2) {
                  seen.push(computed);
                }
                result2.push(value2);
              } else if (!includes2(seen, computed, comparator)) {
                if (seen !== result2) {
                  seen.push(computed);
                }
                result2.push(value2);
              }
            }
          return result2;
        }
        function baseUnset(object, path) {
          path = castPath(path, object);
          object = parent(object, path);
          return object == null || delete object[toKey(last(path))];
        }
        function baseUpdate(object, path, updater, customizer) {
          return baseSet(object, path, updater(baseGet(object, path)), customizer);
        }
        function baseWhile(array, predicate, isDrop, fromRight) {
          var length = array.length, index = fromRight ? length : -1;
          while ((fromRight ? index-- : ++index < length) && predicate(array[index], index, array)) {
          }
          return isDrop ? baseSlice(array, fromRight ? 0 : index, fromRight ? index + 1 : length) : baseSlice(array, fromRight ? index + 1 : 0, fromRight ? length : index);
        }
        function baseWrapperValue(value2, actions) {
          var result2 = value2;
          if (result2 instanceof LazyWrapper) {
            result2 = result2.value();
          }
          return arrayReduce(actions, function(result3, action) {
            return action.func.apply(action.thisArg, arrayPush([result3], action.args));
          }, result2);
        }
        function baseXor(arrays, iteratee2, comparator) {
          var length = arrays.length;
          if (length < 2) {
            return length ? baseUniq(arrays[0]) : [];
          }
          var index = -1, result2 = Array2(length);
          while (++index < length) {
            var array = arrays[index], othIndex = -1;
            while (++othIndex < length) {
              if (othIndex != index) {
                result2[index] = baseDifference(result2[index] || array, arrays[othIndex], iteratee2, comparator);
              }
            }
          }
          return baseUniq(baseFlatten(result2, 1), iteratee2, comparator);
        }
        function baseZipObject(props, values2, assignFunc) {
          var index = -1, length = props.length, valsLength = values2.length, result2 = {};
          while (++index < length) {
            var value2 = index < valsLength ? values2[index] : undefined$1;
            assignFunc(result2, props[index], value2);
          }
          return result2;
        }
        function castArrayLikeObject(value2) {
          return isArrayLikeObject(value2) ? value2 : [];
        }
        function castFunction(value2) {
          return typeof value2 == "function" ? value2 : identity;
        }
        function castPath(value2, object) {
          if (isArray(value2)) {
            return value2;
          }
          return isKey(value2, object) ? [value2] : stringToPath(toString2(value2));
        }
        var castRest = baseRest;
        function castSlice(array, start, end) {
          var length = array.length;
          end = end === undefined$1 ? length : end;
          return !start && end >= length ? array : baseSlice(array, start, end);
        }
        var clearTimeout = ctxClearTimeout || function(id) {
          return root.clearTimeout(id);
        };
        function cloneBuffer(buffer, isDeep) {
          if (isDeep) {
            return buffer.slice();
          }
          var length = buffer.length, result2 = allocUnsafe ? allocUnsafe(length) : new buffer.constructor(length);
          buffer.copy(result2);
          return result2;
        }
        function cloneArrayBuffer(arrayBuffer) {
          var result2 = new arrayBuffer.constructor(arrayBuffer.byteLength);
          new Uint8Array2(result2).set(new Uint8Array2(arrayBuffer));
          return result2;
        }
        function cloneDataView(dataView, isDeep) {
          var buffer = isDeep ? cloneArrayBuffer(dataView.buffer) : dataView.buffer;
          return new dataView.constructor(buffer, dataView.byteOffset, dataView.byteLength);
        }
        function cloneRegExp(regexp) {
          var result2 = new regexp.constructor(regexp.source, reFlags.exec(regexp));
          result2.lastIndex = regexp.lastIndex;
          return result2;
        }
        function cloneSymbol(symbol) {
          return symbolValueOf ? Object2(symbolValueOf.call(symbol)) : {};
        }
        function cloneTypedArray(typedArray, isDeep) {
          var buffer = isDeep ? cloneArrayBuffer(typedArray.buffer) : typedArray.buffer;
          return new typedArray.constructor(buffer, typedArray.byteOffset, typedArray.length);
        }
        function compareAscending(value2, other) {
          if (value2 !== other) {
            var valIsDefined = value2 !== undefined$1, valIsNull = value2 === null, valIsReflexive = value2 === value2, valIsSymbol = isSymbol(value2);
            var othIsDefined = other !== undefined$1, othIsNull = other === null, othIsReflexive = other === other, othIsSymbol = isSymbol(other);
            if (!othIsNull && !othIsSymbol && !valIsSymbol && value2 > other || valIsSymbol && othIsDefined && othIsReflexive && !othIsNull && !othIsSymbol || valIsNull && othIsDefined && othIsReflexive || !valIsDefined && othIsReflexive || !valIsReflexive) {
              return 1;
            }
            if (!valIsNull && !valIsSymbol && !othIsSymbol && value2 < other || othIsSymbol && valIsDefined && valIsReflexive && !valIsNull && !valIsSymbol || othIsNull && valIsDefined && valIsReflexive || !othIsDefined && valIsReflexive || !othIsReflexive) {
              return -1;
            }
          }
          return 0;
        }
        function compareMultiple(object, other, orders) {
          var index = -1, objCriteria = object.criteria, othCriteria = other.criteria, length = objCriteria.length, ordersLength = orders.length;
          while (++index < length) {
            var result2 = compareAscending(objCriteria[index], othCriteria[index]);
            if (result2) {
              if (index >= ordersLength) {
                return result2;
              }
              var order = orders[index];
              return result2 * (order == "desc" ? -1 : 1);
            }
          }
          return object.index - other.index;
        }
        function composeArgs(args, partials, holders, isCurried) {
          var argsIndex = -1, argsLength = args.length, holdersLength = holders.length, leftIndex = -1, leftLength = partials.length, rangeLength = nativeMax(argsLength - holdersLength, 0), result2 = Array2(leftLength + rangeLength), isUncurried = !isCurried;
          while (++leftIndex < leftLength) {
            result2[leftIndex] = partials[leftIndex];
          }
          while (++argsIndex < holdersLength) {
            if (isUncurried || argsIndex < argsLength) {
              result2[holders[argsIndex]] = args[argsIndex];
            }
          }
          while (rangeLength--) {
            result2[leftIndex++] = args[argsIndex++];
          }
          return result2;
        }
        function composeArgsRight(args, partials, holders, isCurried) {
          var argsIndex = -1, argsLength = args.length, holdersIndex = -1, holdersLength = holders.length, rightIndex = -1, rightLength = partials.length, rangeLength = nativeMax(argsLength - holdersLength, 0), result2 = Array2(rangeLength + rightLength), isUncurried = !isCurried;
          while (++argsIndex < rangeLength) {
            result2[argsIndex] = args[argsIndex];
          }
          var offset = argsIndex;
          while (++rightIndex < rightLength) {
            result2[offset + rightIndex] = partials[rightIndex];
          }
          while (++holdersIndex < holdersLength) {
            if (isUncurried || argsIndex < argsLength) {
              result2[offset + holders[holdersIndex]] = args[argsIndex++];
            }
          }
          return result2;
        }
        function copyArray(source, array) {
          var index = -1, length = source.length;
          array || (array = Array2(length));
          while (++index < length) {
            array[index] = source[index];
          }
          return array;
        }
        function copyObject(source, props, object, customizer) {
          var isNew = !object;
          object || (object = {});
          var index = -1, length = props.length;
          while (++index < length) {
            var key = props[index];
            var newValue = customizer ? customizer(object[key], source[key], key, object, source) : undefined$1;
            if (newValue === undefined$1) {
              newValue = source[key];
            }
            if (isNew) {
              baseAssignValue(object, key, newValue);
            } else {
              assignValue(object, key, newValue);
            }
          }
          return object;
        }
        function copySymbols(source, object) {
          return copyObject(source, getSymbols(source), object);
        }
        function copySymbolsIn(source, object) {
          return copyObject(source, getSymbolsIn(source), object);
        }
        function createAggregator(setter, initializer) {
          return function(collection, iteratee2) {
            var func = isArray(collection) ? arrayAggregator : baseAggregator, accumulator = initializer ? initializer() : {};
            return func(collection, setter, getIteratee(iteratee2, 2), accumulator);
          };
        }
        function createAssigner(assigner) {
          return baseRest(function(object, sources) {
            var index = -1, length = sources.length, customizer = length > 1 ? sources[length - 1] : undefined$1, guard = length > 2 ? sources[2] : undefined$1;
            customizer = assigner.length > 3 && typeof customizer == "function" ? (length--, customizer) : undefined$1;
            if (guard && isIterateeCall(sources[0], sources[1], guard)) {
              customizer = length < 3 ? undefined$1 : customizer;
              length = 1;
            }
            object = Object2(object);
            while (++index < length) {
              var source = sources[index];
              if (source) {
                assigner(object, source, index, customizer);
              }
            }
            return object;
          });
        }
        function createBaseEach(eachFunc, fromRight) {
          return function(collection, iteratee2) {
            if (collection == null) {
              return collection;
            }
            if (!isArrayLike(collection)) {
              return eachFunc(collection, iteratee2);
            }
            var length = collection.length, index = fromRight ? length : -1, iterable = Object2(collection);
            while (fromRight ? index-- : ++index < length) {
              if (iteratee2(iterable[index], index, iterable) === false) {
                break;
              }
            }
            return collection;
          };
        }
        function createBaseFor(fromRight) {
          return function(object, iteratee2, keysFunc) {
            var index = -1, iterable = Object2(object), props = keysFunc(object), length = props.length;
            while (length--) {
              var key = props[fromRight ? length : ++index];
              if (iteratee2(iterable[key], key, iterable) === false) {
                break;
              }
            }
            return object;
          };
        }
        function createBind(func, bitmask, thisArg) {
          var isBind = bitmask & WRAP_BIND_FLAG, Ctor = createCtor(func);
          function wrapper() {
            var fn = this && this !== root && this instanceof wrapper ? Ctor : func;
            return fn.apply(isBind ? thisArg : this, arguments);
          }
          return wrapper;
        }
        function createCaseFirst(methodName) {
          return function(string2) {
            string2 = toString2(string2);
            var strSymbols = hasUnicode(string2) ? stringToArray(string2) : undefined$1;
            var chr = strSymbols ? strSymbols[0] : string2.charAt(0);
            var trailing = strSymbols ? castSlice(strSymbols, 1).join("") : string2.slice(1);
            return chr[methodName]() + trailing;
          };
        }
        function createCompounder(callback) {
          return function(string2) {
            return arrayReduce(words(deburr(string2).replace(reApos, "")), callback, "");
          };
        }
        function createCtor(Ctor) {
          return function() {
            var args = arguments;
            switch (args.length) {
              case 0:
                return new Ctor();
              case 1:
                return new Ctor(args[0]);
              case 2:
                return new Ctor(args[0], args[1]);
              case 3:
                return new Ctor(args[0], args[1], args[2]);
              case 4:
                return new Ctor(args[0], args[1], args[2], args[3]);
              case 5:
                return new Ctor(args[0], args[1], args[2], args[3], args[4]);
              case 6:
                return new Ctor(args[0], args[1], args[2], args[3], args[4], args[5]);
              case 7:
                return new Ctor(args[0], args[1], args[2], args[3], args[4], args[5], args[6]);
            }
            var thisBinding = baseCreate(Ctor.prototype), result2 = Ctor.apply(thisBinding, args);
            return isObject2(result2) ? result2 : thisBinding;
          };
        }
        function createCurry(func, bitmask, arity) {
          var Ctor = createCtor(func);
          function wrapper() {
            var length = arguments.length, args = Array2(length), index = length, placeholder = getHolder(wrapper);
            while (index--) {
              args[index] = arguments[index];
            }
            var holders = length < 3 && args[0] !== placeholder && args[length - 1] !== placeholder ? [] : replaceHolders(args, placeholder);
            length -= holders.length;
            if (length < arity) {
              return createRecurry(
                func,
                bitmask,
                createHybrid,
                wrapper.placeholder,
                undefined$1,
                args,
                holders,
                undefined$1,
                undefined$1,
                arity - length
              );
            }
            var fn = this && this !== root && this instanceof wrapper ? Ctor : func;
            return apply(fn, this, args);
          }
          return wrapper;
        }
        function createFind(findIndexFunc) {
          return function(collection, predicate, fromIndex) {
            var iterable = Object2(collection);
            if (!isArrayLike(collection)) {
              var iteratee2 = getIteratee(predicate, 3);
              collection = keys(collection);
              predicate = function(key) {
                return iteratee2(iterable[key], key, iterable);
              };
            }
            var index = findIndexFunc(collection, predicate, fromIndex);
            return index > -1 ? iterable[iteratee2 ? collection[index] : index] : undefined$1;
          };
        }
        function createFlow(fromRight) {
          return flatRest(function(funcs) {
            var length = funcs.length, index = length, prereq = LodashWrapper.prototype.thru;
            if (fromRight) {
              funcs.reverse();
            }
            while (index--) {
              var func = funcs[index];
              if (typeof func != "function") {
                throw new TypeError2(FUNC_ERROR_TEXT);
              }
              if (prereq && !wrapper && getFuncName(func) == "wrapper") {
                var wrapper = new LodashWrapper([], true);
              }
            }
            index = wrapper ? index : length;
            while (++index < length) {
              func = funcs[index];
              var funcName = getFuncName(func), data2 = funcName == "wrapper" ? getData(func) : undefined$1;
              if (data2 && isLaziable(data2[0]) && data2[1] == (WRAP_ARY_FLAG | WRAP_CURRY_FLAG | WRAP_PARTIAL_FLAG | WRAP_REARG_FLAG) && !data2[4].length && data2[9] == 1) {
                wrapper = wrapper[getFuncName(data2[0])].apply(wrapper, data2[3]);
              } else {
                wrapper = func.length == 1 && isLaziable(func) ? wrapper[funcName]() : wrapper.thru(func);
              }
            }
            return function() {
              var args = arguments, value2 = args[0];
              if (wrapper && args.length == 1 && isArray(value2)) {
                return wrapper.plant(value2).value();
              }
              var index2 = 0, result2 = length ? funcs[index2].apply(this, args) : value2;
              while (++index2 < length) {
                result2 = funcs[index2].call(this, result2);
              }
              return result2;
            };
          });
        }
        function createHybrid(func, bitmask, thisArg, partials, holders, partialsRight, holdersRight, argPos, ary2, arity) {
          var isAry = bitmask & WRAP_ARY_FLAG, isBind = bitmask & WRAP_BIND_FLAG, isBindKey = bitmask & WRAP_BIND_KEY_FLAG, isCurried = bitmask & (WRAP_CURRY_FLAG | WRAP_CURRY_RIGHT_FLAG), isFlip = bitmask & WRAP_FLIP_FLAG, Ctor = isBindKey ? undefined$1 : createCtor(func);
          function wrapper() {
            var length = arguments.length, args = Array2(length), index = length;
            while (index--) {
              args[index] = arguments[index];
            }
            if (isCurried) {
              var placeholder = getHolder(wrapper), holdersCount = countHolders(args, placeholder);
            }
            if (partials) {
              args = composeArgs(args, partials, holders, isCurried);
            }
            if (partialsRight) {
              args = composeArgsRight(args, partialsRight, holdersRight, isCurried);
            }
            length -= holdersCount;
            if (isCurried && length < arity) {
              var newHolders = replaceHolders(args, placeholder);
              return createRecurry(
                func,
                bitmask,
                createHybrid,
                wrapper.placeholder,
                thisArg,
                args,
                newHolders,
                argPos,
                ary2,
                arity - length
              );
            }
            var thisBinding = isBind ? thisArg : this, fn = isBindKey ? thisBinding[func] : func;
            length = args.length;
            if (argPos) {
              args = reorder(args, argPos);
            } else if (isFlip && length > 1) {
              args.reverse();
            }
            if (isAry && ary2 < length) {
              args.length = ary2;
            }
            if (this && this !== root && this instanceof wrapper) {
              fn = Ctor || createCtor(fn);
            }
            return fn.apply(thisBinding, args);
          }
          return wrapper;
        }
        function createInverter(setter, toIteratee) {
          return function(object, iteratee2) {
            return baseInverter(object, setter, toIteratee(iteratee2), {});
          };
        }
        function createMathOperation(operator, defaultValue) {
          return function(value2, other) {
            var result2;
            if (value2 === undefined$1 && other === undefined$1) {
              return defaultValue;
            }
            if (value2 !== undefined$1) {
              result2 = value2;
            }
            if (other !== undefined$1) {
              if (result2 === undefined$1) {
                return other;
              }
              if (typeof value2 == "string" || typeof other == "string") {
                value2 = baseToString(value2);
                other = baseToString(other);
              } else {
                value2 = baseToNumber(value2);
                other = baseToNumber(other);
              }
              result2 = operator(value2, other);
            }
            return result2;
          };
        }
        function createOver(arrayFunc) {
          return flatRest(function(iteratees) {
            iteratees = arrayMap(iteratees, baseUnary(getIteratee()));
            return baseRest(function(args) {
              var thisArg = this;
              return arrayFunc(iteratees, function(iteratee2) {
                return apply(iteratee2, thisArg, args);
              });
            });
          });
        }
        function createPadding(length, chars) {
          chars = chars === undefined$1 ? " " : baseToString(chars);
          var charsLength = chars.length;
          if (charsLength < 2) {
            return charsLength ? baseRepeat(chars, length) : chars;
          }
          var result2 = baseRepeat(chars, nativeCeil(length / stringSize(chars)));
          return hasUnicode(chars) ? castSlice(stringToArray(result2), 0, length).join("") : result2.slice(0, length);
        }
        function createPartial(func, bitmask, thisArg, partials) {
          var isBind = bitmask & WRAP_BIND_FLAG, Ctor = createCtor(func);
          function wrapper() {
            var argsIndex = -1, argsLength = arguments.length, leftIndex = -1, leftLength = partials.length, args = Array2(leftLength + argsLength), fn = this && this !== root && this instanceof wrapper ? Ctor : func;
            while (++leftIndex < leftLength) {
              args[leftIndex] = partials[leftIndex];
            }
            while (argsLength--) {
              args[leftIndex++] = arguments[++argsIndex];
            }
            return apply(fn, isBind ? thisArg : this, args);
          }
          return wrapper;
        }
        function createRange(fromRight) {
          return function(start, end, step) {
            if (step && typeof step != "number" && isIterateeCall(start, end, step)) {
              end = step = undefined$1;
            }
            start = toFinite(start);
            if (end === undefined$1) {
              end = start;
              start = 0;
            } else {
              end = toFinite(end);
            }
            step = step === undefined$1 ? start < end ? 1 : -1 : toFinite(step);
            return baseRange(start, end, step, fromRight);
          };
        }
        function createRelationalOperation(operator) {
          return function(value2, other) {
            if (!(typeof value2 == "string" && typeof other == "string")) {
              value2 = toNumber(value2);
              other = toNumber(other);
            }
            return operator(value2, other);
          };
        }
        function createRecurry(func, bitmask, wrapFunc, placeholder, thisArg, partials, holders, argPos, ary2, arity) {
          var isCurry = bitmask & WRAP_CURRY_FLAG, newHolders = isCurry ? holders : undefined$1, newHoldersRight = isCurry ? undefined$1 : holders, newPartials = isCurry ? partials : undefined$1, newPartialsRight = isCurry ? undefined$1 : partials;
          bitmask |= isCurry ? WRAP_PARTIAL_FLAG : WRAP_PARTIAL_RIGHT_FLAG;
          bitmask &= ~(isCurry ? WRAP_PARTIAL_RIGHT_FLAG : WRAP_PARTIAL_FLAG);
          if (!(bitmask & WRAP_CURRY_BOUND_FLAG)) {
            bitmask &= ~(WRAP_BIND_FLAG | WRAP_BIND_KEY_FLAG);
          }
          var newData = [
            func,
            bitmask,
            thisArg,
            newPartials,
            newHolders,
            newPartialsRight,
            newHoldersRight,
            argPos,
            ary2,
            arity
          ];
          var result2 = wrapFunc.apply(undefined$1, newData);
          if (isLaziable(func)) {
            setData(result2, newData);
          }
          result2.placeholder = placeholder;
          return setWrapToString(result2, func, bitmask);
        }
        function createRound(methodName) {
          var func = Math2[methodName];
          return function(number, precision) {
            number = toNumber(number);
            precision = precision == null ? 0 : nativeMin(toInteger(precision), 292);
            if (precision && nativeIsFinite(number)) {
              var pair = (toString2(number) + "e").split("e"), value2 = func(pair[0] + "e" + (+pair[1] + precision));
              pair = (toString2(value2) + "e").split("e");
              return +(pair[0] + "e" + (+pair[1] - precision));
            }
            return func(number);
          };
        }
        var createSet = !(Set2 && 1 / setToArray(new Set2([, -0]))[1] == INFINITY) ? noop : function(values2) {
          return new Set2(values2);
        };
        function createToPairs(keysFunc) {
          return function(object) {
            var tag = getTag(object);
            if (tag == mapTag) {
              return mapToArray(object);
            }
            if (tag == setTag) {
              return setToPairs(object);
            }
            return baseToPairs(object, keysFunc(object));
          };
        }
        function createWrap(func, bitmask, thisArg, partials, holders, argPos, ary2, arity) {
          var isBindKey = bitmask & WRAP_BIND_KEY_FLAG;
          if (!isBindKey && typeof func != "function") {
            throw new TypeError2(FUNC_ERROR_TEXT);
          }
          var length = partials ? partials.length : 0;
          if (!length) {
            bitmask &= ~(WRAP_PARTIAL_FLAG | WRAP_PARTIAL_RIGHT_FLAG);
            partials = holders = undefined$1;
          }
          ary2 = ary2 === undefined$1 ? ary2 : nativeMax(toInteger(ary2), 0);
          arity = arity === undefined$1 ? arity : toInteger(arity);
          length -= holders ? holders.length : 0;
          if (bitmask & WRAP_PARTIAL_RIGHT_FLAG) {
            var partialsRight = partials, holdersRight = holders;
            partials = holders = undefined$1;
          }
          var data2 = isBindKey ? undefined$1 : getData(func);
          var newData = [
            func,
            bitmask,
            thisArg,
            partials,
            holders,
            partialsRight,
            holdersRight,
            argPos,
            ary2,
            arity
          ];
          if (data2) {
            mergeData(newData, data2);
          }
          func = newData[0];
          bitmask = newData[1];
          thisArg = newData[2];
          partials = newData[3];
          holders = newData[4];
          arity = newData[9] = newData[9] === undefined$1 ? isBindKey ? 0 : func.length : nativeMax(newData[9] - length, 0);
          if (!arity && bitmask & (WRAP_CURRY_FLAG | WRAP_CURRY_RIGHT_FLAG)) {
            bitmask &= ~(WRAP_CURRY_FLAG | WRAP_CURRY_RIGHT_FLAG);
          }
          if (!bitmask || bitmask == WRAP_BIND_FLAG) {
            var result2 = createBind(func, bitmask, thisArg);
          } else if (bitmask == WRAP_CURRY_FLAG || bitmask == WRAP_CURRY_RIGHT_FLAG) {
            result2 = createCurry(func, bitmask, arity);
          } else if ((bitmask == WRAP_PARTIAL_FLAG || bitmask == (WRAP_BIND_FLAG | WRAP_PARTIAL_FLAG)) && !holders.length) {
            result2 = createPartial(func, bitmask, thisArg, partials);
          } else {
            result2 = createHybrid.apply(undefined$1, newData);
          }
          var setter = data2 ? baseSetData : setData;
          return setWrapToString(setter(result2, newData), func, bitmask);
        }
        function customDefaultsAssignIn(objValue, srcValue, key, object) {
          if (objValue === undefined$1 || eq(objValue, objectProto[key]) && !hasOwnProperty.call(object, key)) {
            return srcValue;
          }
          return objValue;
        }
        function customDefaultsMerge(objValue, srcValue, key, object, source, stack) {
          if (isObject2(objValue) && isObject2(srcValue)) {
            stack.set(srcValue, objValue);
            baseMerge(objValue, srcValue, undefined$1, customDefaultsMerge, stack);
            stack["delete"](srcValue);
          }
          return objValue;
        }
        function customOmitClone(value2) {
          return isPlainObject(value2) ? undefined$1 : value2;
        }
        function equalArrays(array, other, bitmask, customizer, equalFunc, stack) {
          var isPartial = bitmask & COMPARE_PARTIAL_FLAG, arrLength = array.length, othLength = other.length;
          if (arrLength != othLength && !(isPartial && othLength > arrLength)) {
            return false;
          }
          var arrStacked = stack.get(array);
          var othStacked = stack.get(other);
          if (arrStacked && othStacked) {
            return arrStacked == other && othStacked == array;
          }
          var index = -1, result2 = true, seen = bitmask & COMPARE_UNORDERED_FLAG ? new SetCache() : undefined$1;
          stack.set(array, other);
          stack.set(other, array);
          while (++index < arrLength) {
            var arrValue = array[index], othValue = other[index];
            if (customizer) {
              var compared = isPartial ? customizer(othValue, arrValue, index, other, array, stack) : customizer(arrValue, othValue, index, array, other, stack);
            }
            if (compared !== undefined$1) {
              if (compared) {
                continue;
              }
              result2 = false;
              break;
            }
            if (seen) {
              if (!arraySome(other, function(othValue2, othIndex) {
                if (!cacheHas(seen, othIndex) && (arrValue === othValue2 || equalFunc(arrValue, othValue2, bitmask, customizer, stack))) {
                  return seen.push(othIndex);
                }
              })) {
                result2 = false;
                break;
              }
            } else if (!(arrValue === othValue || equalFunc(arrValue, othValue, bitmask, customizer, stack))) {
              result2 = false;
              break;
            }
          }
          stack["delete"](array);
          stack["delete"](other);
          return result2;
        }
        function equalByTag(object, other, tag, bitmask, customizer, equalFunc, stack) {
          switch (tag) {
            case dataViewTag:
              if (object.byteLength != other.byteLength || object.byteOffset != other.byteOffset) {
                return false;
              }
              object = object.buffer;
              other = other.buffer;
            case arrayBufferTag:
              if (object.byteLength != other.byteLength || !equalFunc(new Uint8Array2(object), new Uint8Array2(other))) {
                return false;
              }
              return true;
            case boolTag:
            case dateTag:
            case numberTag:
              return eq(+object, +other);
            case errorTag:
              return object.name == other.name && object.message == other.message;
            case regexpTag:
            case stringTag:
              return object == other + "";
            case mapTag:
              var convert = mapToArray;
            case setTag:
              var isPartial = bitmask & COMPARE_PARTIAL_FLAG;
              convert || (convert = setToArray);
              if (object.size != other.size && !isPartial) {
                return false;
              }
              var stacked = stack.get(object);
              if (stacked) {
                return stacked == other;
              }
              bitmask |= COMPARE_UNORDERED_FLAG;
              stack.set(object, other);
              var result2 = equalArrays(convert(object), convert(other), bitmask, customizer, equalFunc, stack);
              stack["delete"](object);
              return result2;
            case symbolTag:
              if (symbolValueOf) {
                return symbolValueOf.call(object) == symbolValueOf.call(other);
              }
          }
          return false;
        }
        function equalObjects(object, other, bitmask, customizer, equalFunc, stack) {
          var isPartial = bitmask & COMPARE_PARTIAL_FLAG, objProps = getAllKeys(object), objLength = objProps.length, othProps = getAllKeys(other), othLength = othProps.length;
          if (objLength != othLength && !isPartial) {
            return false;
          }
          var index = objLength;
          while (index--) {
            var key = objProps[index];
            if (!(isPartial ? key in other : hasOwnProperty.call(other, key))) {
              return false;
            }
          }
          var objStacked = stack.get(object);
          var othStacked = stack.get(other);
          if (objStacked && othStacked) {
            return objStacked == other && othStacked == object;
          }
          var result2 = true;
          stack.set(object, other);
          stack.set(other, object);
          var skipCtor = isPartial;
          while (++index < objLength) {
            key = objProps[index];
            var objValue = object[key], othValue = other[key];
            if (customizer) {
              var compared = isPartial ? customizer(othValue, objValue, key, other, object, stack) : customizer(objValue, othValue, key, object, other, stack);
            }
            if (!(compared === undefined$1 ? objValue === othValue || equalFunc(objValue, othValue, bitmask, customizer, stack) : compared)) {
              result2 = false;
              break;
            }
            skipCtor || (skipCtor = key == "constructor");
          }
          if (result2 && !skipCtor) {
            var objCtor = object.constructor, othCtor = other.constructor;
            if (objCtor != othCtor && ("constructor" in object && "constructor" in other) && !(typeof objCtor == "function" && objCtor instanceof objCtor && typeof othCtor == "function" && othCtor instanceof othCtor)) {
              result2 = false;
            }
          }
          stack["delete"](object);
          stack["delete"](other);
          return result2;
        }
        function flatRest(func) {
          return setToString(overRest(func, undefined$1, flatten), func + "");
        }
        function getAllKeys(object) {
          return baseGetAllKeys(object, keys, getSymbols);
        }
        function getAllKeysIn(object) {
          return baseGetAllKeys(object, keysIn, getSymbolsIn);
        }
        var getData = !metaMap ? noop : function(func) {
          return metaMap.get(func);
        };
        function getFuncName(func) {
          var result2 = func.name + "", array = realNames[result2], length = hasOwnProperty.call(realNames, result2) ? array.length : 0;
          while (length--) {
            var data2 = array[length], otherFunc = data2.func;
            if (otherFunc == null || otherFunc == func) {
              return data2.name;
            }
          }
          return result2;
        }
        function getHolder(func) {
          var object = hasOwnProperty.call(lodash2, "placeholder") ? lodash2 : func;
          return object.placeholder;
        }
        function getIteratee() {
          var result2 = lodash2.iteratee || iteratee;
          result2 = result2 === iteratee ? baseIteratee : result2;
          return arguments.length ? result2(arguments[0], arguments[1]) : result2;
        }
        function getMapData(map3, key) {
          var data2 = map3.__data__;
          return isKeyable(key) ? data2[typeof key == "string" ? "string" : "hash"] : data2.map;
        }
        function getMatchData(object) {
          var result2 = keys(object), length = result2.length;
          while (length--) {
            var key = result2[length], value2 = object[key];
            result2[length] = [key, value2, isStrictComparable(value2)];
          }
          return result2;
        }
        function getNative(object, key) {
          var value2 = getValue(object, key);
          return baseIsNative(value2) ? value2 : undefined$1;
        }
        function getRawTag(value2) {
          var isOwn = hasOwnProperty.call(value2, symToStringTag), tag = value2[symToStringTag];
          try {
            value2[symToStringTag] = undefined$1;
            var unmasked = true;
          } catch (e) {
          }
          var result2 = nativeObjectToString.call(value2);
          if (unmasked) {
            if (isOwn) {
              value2[symToStringTag] = tag;
            } else {
              delete value2[symToStringTag];
            }
          }
          return result2;
        }
        var getSymbols = !nativeGetSymbols ? stubArray : function(object) {
          if (object == null) {
            return [];
          }
          object = Object2(object);
          return arrayFilter(nativeGetSymbols(object), function(symbol) {
            return propertyIsEnumerable.call(object, symbol);
          });
        };
        var getSymbolsIn = !nativeGetSymbols ? stubArray : function(object) {
          var result2 = [];
          while (object) {
            arrayPush(result2, getSymbols(object));
            object = getPrototype(object);
          }
          return result2;
        };
        var getTag = baseGetTag;
        if (DataView && getTag(new DataView(new ArrayBuffer(1))) != dataViewTag || Map && getTag(new Map()) != mapTag || Promise2 && getTag(Promise2.resolve()) != promiseTag || Set2 && getTag(new Set2()) != setTag || WeakMap && getTag(new WeakMap()) != weakMapTag) {
          getTag = function(value2) {
            var result2 = baseGetTag(value2), Ctor = result2 == objectTag ? value2.constructor : undefined$1, ctorString = Ctor ? toSource(Ctor) : "";
            if (ctorString) {
              switch (ctorString) {
                case dataViewCtorString:
                  return dataViewTag;
                case mapCtorString:
                  return mapTag;
                case promiseCtorString:
                  return promiseTag;
                case setCtorString:
                  return setTag;
                case weakMapCtorString:
                  return weakMapTag;
              }
            }
            return result2;
          };
        }
        function getView(start, end, transforms) {
          var index = -1, length = transforms.length;
          while (++index < length) {
            var data2 = transforms[index], size2 = data2.size;
            switch (data2.type) {
              case "drop":
                start += size2;
                break;
              case "dropRight":
                end -= size2;
                break;
              case "take":
                end = nativeMin(end, start + size2);
                break;
              case "takeRight":
                start = nativeMax(start, end - size2);
                break;
            }
          }
          return { "start": start, "end": end };
        }
        function getWrapDetails(source) {
          var match = source.match(reWrapDetails);
          return match ? match[1].split(reSplitDetails) : [];
        }
        function hasPath(object, path, hasFunc) {
          path = castPath(path, object);
          var index = -1, length = path.length, result2 = false;
          while (++index < length) {
            var key = toKey(path[index]);
            if (!(result2 = object != null && hasFunc(object, key))) {
              break;
            }
            object = object[key];
          }
          if (result2 || ++index != length) {
            return result2;
          }
          length = object == null ? 0 : object.length;
          return !!length && isLength(length) && isIndex(key, length) && (isArray(object) || isArguments(object));
        }
        function initCloneArray(array) {
          var length = array.length, result2 = new array.constructor(length);
          if (length && typeof array[0] == "string" && hasOwnProperty.call(array, "index")) {
            result2.index = array.index;
            result2.input = array.input;
          }
          return result2;
        }
        function initCloneObject(object) {
          return typeof object.constructor == "function" && !isPrototype(object) ? baseCreate(getPrototype(object)) : {};
        }
        function initCloneByTag(object, tag, isDeep) {
          var Ctor = object.constructor;
          switch (tag) {
            case arrayBufferTag:
              return cloneArrayBuffer(object);
            case boolTag:
            case dateTag:
              return new Ctor(+object);
            case dataViewTag:
              return cloneDataView(object, isDeep);
            case float32Tag:
            case float64Tag:
            case int8Tag:
            case int16Tag:
            case int32Tag:
            case uint8Tag:
            case uint8ClampedTag:
            case uint16Tag:
            case uint32Tag:
              return cloneTypedArray(object, isDeep);
            case mapTag:
              return new Ctor();
            case numberTag:
            case stringTag:
              return new Ctor(object);
            case regexpTag:
              return cloneRegExp(object);
            case setTag:
              return new Ctor();
            case symbolTag:
              return cloneSymbol(object);
          }
        }
        function insertWrapDetails(source, details) {
          var length = details.length;
          if (!length) {
            return source;
          }
          var lastIndex = length - 1;
          details[lastIndex] = (length > 1 ? "& " : "") + details[lastIndex];
          details = details.join(length > 2 ? ", " : " ");
          return source.replace(reWrapComment, "{\n/* [wrapped with " + details + "] */\n");
        }
        function isFlattenable(value2) {
          return isArray(value2) || isArguments(value2) || !!(spreadableSymbol && value2 && value2[spreadableSymbol]);
        }
        function isIndex(value2, length) {
          var type = typeof value2;
          length = length == null ? MAX_SAFE_INTEGER : length;
          return !!length && (type == "number" || type != "symbol" && reIsUint.test(value2)) && (value2 > -1 && value2 % 1 == 0 && value2 < length);
        }
        function isIterateeCall(value2, index, object) {
          if (!isObject2(object)) {
            return false;
          }
          var type = typeof index;
          if (type == "number" ? isArrayLike(object) && isIndex(index, object.length) : type == "string" && index in object) {
            return eq(object[index], value2);
          }
          return false;
        }
        function isKey(value2, object) {
          if (isArray(value2)) {
            return false;
          }
          var type = typeof value2;
          if (type == "number" || type == "symbol" || type == "boolean" || value2 == null || isSymbol(value2)) {
            return true;
          }
          return reIsPlainProp.test(value2) || !reIsDeepProp.test(value2) || object != null && value2 in Object2(object);
        }
        function isKeyable(value2) {
          var type = typeof value2;
          return type == "string" || type == "number" || type == "symbol" || type == "boolean" ? value2 !== "__proto__" : value2 === null;
        }
        function isLaziable(func) {
          var funcName = getFuncName(func), other = lodash2[funcName];
          if (typeof other != "function" || !(funcName in LazyWrapper.prototype)) {
            return false;
          }
          if (func === other) {
            return true;
          }
          var data2 = getData(other);
          return !!data2 && func === data2[0];
        }
        function isMasked(func) {
          return !!maskSrcKey && maskSrcKey in func;
        }
        var isMaskable = coreJsData ? isFunction : stubFalse;
        function isPrototype(value2) {
          var Ctor = value2 && value2.constructor, proto = typeof Ctor == "function" && Ctor.prototype || objectProto;
          return value2 === proto;
        }
        function isStrictComparable(value2) {
          return value2 === value2 && !isObject2(value2);
        }
        function matchesStrictComparable(key, srcValue) {
          return function(object) {
            if (object == null) {
              return false;
            }
            return object[key] === srcValue && (srcValue !== undefined$1 || key in Object2(object));
          };
        }
        function memoizeCapped(func) {
          var result2 = memoize2(func, function(key) {
            if (cache.size === MAX_MEMOIZE_SIZE) {
              cache.clear();
            }
            return key;
          });
          var cache = result2.cache;
          return result2;
        }
        function mergeData(data2, source) {
          var bitmask = data2[1], srcBitmask = source[1], newBitmask = bitmask | srcBitmask, isCommon = newBitmask < (WRAP_BIND_FLAG | WRAP_BIND_KEY_FLAG | WRAP_ARY_FLAG);
          var isCombo = srcBitmask == WRAP_ARY_FLAG && bitmask == WRAP_CURRY_FLAG || srcBitmask == WRAP_ARY_FLAG && bitmask == WRAP_REARG_FLAG && data2[7].length <= source[8] || srcBitmask == (WRAP_ARY_FLAG | WRAP_REARG_FLAG) && source[7].length <= source[8] && bitmask == WRAP_CURRY_FLAG;
          if (!(isCommon || isCombo)) {
            return data2;
          }
          if (srcBitmask & WRAP_BIND_FLAG) {
            data2[2] = source[2];
            newBitmask |= bitmask & WRAP_BIND_FLAG ? 0 : WRAP_CURRY_BOUND_FLAG;
          }
          var value2 = source[3];
          if (value2) {
            var partials = data2[3];
            data2[3] = partials ? composeArgs(partials, value2, source[4]) : value2;
            data2[4] = partials ? replaceHolders(data2[3], PLACEHOLDER) : source[4];
          }
          value2 = source[5];
          if (value2) {
            partials = data2[5];
            data2[5] = partials ? composeArgsRight(partials, value2, source[6]) : value2;
            data2[6] = partials ? replaceHolders(data2[5], PLACEHOLDER) : source[6];
          }
          value2 = source[7];
          if (value2) {
            data2[7] = value2;
          }
          if (srcBitmask & WRAP_ARY_FLAG) {
            data2[8] = data2[8] == null ? source[8] : nativeMin(data2[8], source[8]);
          }
          if (data2[9] == null) {
            data2[9] = source[9];
          }
          data2[0] = source[0];
          data2[1] = newBitmask;
          return data2;
        }
        function nativeKeysIn(object) {
          var result2 = [];
          if (object != null) {
            for (var key in Object2(object)) {
              result2.push(key);
            }
          }
          return result2;
        }
        function objectToString(value2) {
          return nativeObjectToString.call(value2);
        }
        function overRest(func, start, transform2) {
          start = nativeMax(start === undefined$1 ? func.length - 1 : start, 0);
          return function() {
            var args = arguments, index = -1, length = nativeMax(args.length - start, 0), array = Array2(length);
            while (++index < length) {
              array[index] = args[start + index];
            }
            index = -1;
            var otherArgs = Array2(start + 1);
            while (++index < start) {
              otherArgs[index] = args[index];
            }
            otherArgs[start] = transform2(array);
            return apply(func, this, otherArgs);
          };
        }
        function parent(object, path) {
          return path.length < 2 ? object : baseGet(object, baseSlice(path, 0, -1));
        }
        function reorder(array, indexes) {
          var arrLength = array.length, length = nativeMin(indexes.length, arrLength), oldArray = copyArray(array);
          while (length--) {
            var index = indexes[length];
            array[length] = isIndex(index, arrLength) ? oldArray[index] : undefined$1;
          }
          return array;
        }
        function safeGet(object, key) {
          if (key === "constructor" && typeof object[key] === "function") {
            return;
          }
          if (key == "__proto__") {
            return;
          }
          return object[key];
        }
        var setData = shortOut(baseSetData);
        var setTimeout = ctxSetTimeout || function(func, wait) {
          return root.setTimeout(func, wait);
        };
        var setToString = shortOut(baseSetToString);
        function setWrapToString(wrapper, reference2, bitmask) {
          var source = reference2 + "";
          return setToString(wrapper, insertWrapDetails(source, updateWrapDetails(getWrapDetails(source), bitmask)));
        }
        function shortOut(func) {
          var count = 0, lastCalled = 0;
          return function() {
            var stamp = nativeNow(), remaining = HOT_SPAN - (stamp - lastCalled);
            lastCalled = stamp;
            if (remaining > 0) {
              if (++count >= HOT_COUNT) {
                return arguments[0];
              }
            } else {
              count = 0;
            }
            return func.apply(undefined$1, arguments);
          };
        }
        function shuffleSelf(array, size2) {
          var index = -1, length = array.length, lastIndex = length - 1;
          size2 = size2 === undefined$1 ? length : size2;
          while (++index < size2) {
            var rand = baseRandom(index, lastIndex), value2 = array[rand];
            array[rand] = array[index];
            array[index] = value2;
          }
          array.length = size2;
          return array;
        }
        var stringToPath = memoizeCapped(function(string2) {
          var result2 = [];
          if (string2.charCodeAt(0) === 46) {
            result2.push("");
          }
          string2.replace(rePropName, function(match, number, quote, subString) {
            result2.push(quote ? subString.replace(reEscapeChar, "$1") : number || match);
          });
          return result2;
        });
        function toKey(value2) {
          if (typeof value2 == "string" || isSymbol(value2)) {
            return value2;
          }
          var result2 = value2 + "";
          return result2 == "0" && 1 / value2 == -INFINITY ? "-0" : result2;
        }
        function toSource(func) {
          if (func != null) {
            try {
              return funcToString.call(func);
            } catch (e) {
            }
            try {
              return func + "";
            } catch (e) {
            }
          }
          return "";
        }
        function updateWrapDetails(details, bitmask) {
          arrayEach(wrapFlags, function(pair) {
            var value2 = "_." + pair[0];
            if (bitmask & pair[1] && !arrayIncludes(details, value2)) {
              details.push(value2);
            }
          });
          return details.sort();
        }
        function wrapperClone(wrapper) {
          if (wrapper instanceof LazyWrapper) {
            return wrapper.clone();
          }
          var result2 = new LodashWrapper(wrapper.__wrapped__, wrapper.__chain__);
          result2.__actions__ = copyArray(wrapper.__actions__);
          result2.__index__ = wrapper.__index__;
          result2.__values__ = wrapper.__values__;
          return result2;
        }
        function chunk(array, size2, guard) {
          if (guard ? isIterateeCall(array, size2, guard) : size2 === undefined$1) {
            size2 = 1;
          } else {
            size2 = nativeMax(toInteger(size2), 0);
          }
          var length = array == null ? 0 : array.length;
          if (!length || size2 < 1) {
            return [];
          }
          var index = 0, resIndex = 0, result2 = Array2(nativeCeil(length / size2));
          while (index < length) {
            result2[resIndex++] = baseSlice(array, index, index += size2);
          }
          return result2;
        }
        function compact(array) {
          var index = -1, length = array == null ? 0 : array.length, resIndex = 0, result2 = [];
          while (++index < length) {
            var value2 = array[index];
            if (value2) {
              result2[resIndex++] = value2;
            }
          }
          return result2;
        }
        function concat() {
          var length = arguments.length;
          if (!length) {
            return [];
          }
          var args = Array2(length - 1), array = arguments[0], index = length;
          while (index--) {
            args[index - 1] = arguments[index];
          }
          return arrayPush(isArray(array) ? copyArray(array) : [array], baseFlatten(args, 1));
        }
        var difference = baseRest(function(array, values2) {
          return isArrayLikeObject(array) ? baseDifference(array, baseFlatten(values2, 1, isArrayLikeObject, true)) : [];
        });
        var differenceBy = baseRest(function(array, values2) {
          var iteratee2 = last(values2);
          if (isArrayLikeObject(iteratee2)) {
            iteratee2 = undefined$1;
          }
          return isArrayLikeObject(array) ? baseDifference(array, baseFlatten(values2, 1, isArrayLikeObject, true), getIteratee(iteratee2, 2)) : [];
        });
        var differenceWith = baseRest(function(array, values2) {
          var comparator = last(values2);
          if (isArrayLikeObject(comparator)) {
            comparator = undefined$1;
          }
          return isArrayLikeObject(array) ? baseDifference(array, baseFlatten(values2, 1, isArrayLikeObject, true), undefined$1, comparator) : [];
        });
        function drop(array, n, guard) {
          var length = array == null ? 0 : array.length;
          if (!length) {
            return [];
          }
          n = guard || n === undefined$1 ? 1 : toInteger(n);
          return baseSlice(array, n < 0 ? 0 : n, length);
        }
        function dropRight(array, n, guard) {
          var length = array == null ? 0 : array.length;
          if (!length) {
            return [];
          }
          n = guard || n === undefined$1 ? 1 : toInteger(n);
          n = length - n;
          return baseSlice(array, 0, n < 0 ? 0 : n);
        }
        function dropRightWhile(array, predicate) {
          return array && array.length ? baseWhile(array, getIteratee(predicate, 3), true, true) : [];
        }
        function dropWhile(array, predicate) {
          return array && array.length ? baseWhile(array, getIteratee(predicate, 3), true) : [];
        }
        function fill(array, value2, start, end) {
          var length = array == null ? 0 : array.length;
          if (!length) {
            return [];
          }
          if (start && typeof start != "number" && isIterateeCall(array, value2, start)) {
            start = 0;
            end = length;
          }
          return baseFill(array, value2, start, end);
        }
        function findIndex(array, predicate, fromIndex) {
          var length = array == null ? 0 : array.length;
          if (!length) {
            return -1;
          }
          var index = fromIndex == null ? 0 : toInteger(fromIndex);
          if (index < 0) {
            index = nativeMax(length + index, 0);
          }
          return baseFindIndex(array, getIteratee(predicate, 3), index);
        }
        function findLastIndex(array, predicate, fromIndex) {
          var length = array == null ? 0 : array.length;
          if (!length) {
            return -1;
          }
          var index = length - 1;
          if (fromIndex !== undefined$1) {
            index = toInteger(fromIndex);
            index = fromIndex < 0 ? nativeMax(length + index, 0) : nativeMin(index, length - 1);
          }
          return baseFindIndex(array, getIteratee(predicate, 3), index, true);
        }
        function flatten(array) {
          var length = array == null ? 0 : array.length;
          return length ? baseFlatten(array, 1) : [];
        }
        function flattenDeep(array) {
          var length = array == null ? 0 : array.length;
          return length ? baseFlatten(array, INFINITY) : [];
        }
        function flattenDepth(array, depth) {
          var length = array == null ? 0 : array.length;
          if (!length) {
            return [];
          }
          depth = depth === undefined$1 ? 1 : toInteger(depth);
          return baseFlatten(array, depth);
        }
        function fromPairs(pairs) {
          var index = -1, length = pairs == null ? 0 : pairs.length, result2 = {};
          while (++index < length) {
            var pair = pairs[index];
            result2[pair[0]] = pair[1];
          }
          return result2;
        }
        function head(array) {
          return array && array.length ? array[0] : undefined$1;
        }
        function indexOf(array, value2, fromIndex) {
          var length = array == null ? 0 : array.length;
          if (!length) {
            return -1;
          }
          var index = fromIndex == null ? 0 : toInteger(fromIndex);
          if (index < 0) {
            index = nativeMax(length + index, 0);
          }
          return baseIndexOf(array, value2, index);
        }
        function initial(array) {
          var length = array == null ? 0 : array.length;
          return length ? baseSlice(array, 0, -1) : [];
        }
        var intersection = baseRest(function(arrays) {
          var mapped = arrayMap(arrays, castArrayLikeObject);
          return mapped.length && mapped[0] === arrays[0] ? baseIntersection(mapped) : [];
        });
        var intersectionBy = baseRest(function(arrays) {
          var iteratee2 = last(arrays), mapped = arrayMap(arrays, castArrayLikeObject);
          if (iteratee2 === last(mapped)) {
            iteratee2 = undefined$1;
          } else {
            mapped.pop();
          }
          return mapped.length && mapped[0] === arrays[0] ? baseIntersection(mapped, getIteratee(iteratee2, 2)) : [];
        });
        var intersectionWith = baseRest(function(arrays) {
          var comparator = last(arrays), mapped = arrayMap(arrays, castArrayLikeObject);
          comparator = typeof comparator == "function" ? comparator : undefined$1;
          if (comparator) {
            mapped.pop();
          }
          return mapped.length && mapped[0] === arrays[0] ? baseIntersection(mapped, undefined$1, comparator) : [];
        });
        function join(array, separator) {
          return array == null ? "" : nativeJoin.call(array, separator);
        }
        function last(array) {
          var length = array == null ? 0 : array.length;
          return length ? array[length - 1] : undefined$1;
        }
        function lastIndexOf(array, value2, fromIndex) {
          var length = array == null ? 0 : array.length;
          if (!length) {
            return -1;
          }
          var index = length;
          if (fromIndex !== undefined$1) {
            index = toInteger(fromIndex);
            index = index < 0 ? nativeMax(length + index, 0) : nativeMin(index, length - 1);
          }
          return value2 === value2 ? strictLastIndexOf(array, value2, index) : baseFindIndex(array, baseIsNaN, index, true);
        }
        function nth(array, n) {
          return array && array.length ? baseNth(array, toInteger(n)) : undefined$1;
        }
        var pull = baseRest(pullAll);
        function pullAll(array, values2) {
          return array && array.length && values2 && values2.length ? basePullAll(array, values2) : array;
        }
        function pullAllBy(array, values2, iteratee2) {
          return array && array.length && values2 && values2.length ? basePullAll(array, values2, getIteratee(iteratee2, 2)) : array;
        }
        function pullAllWith(array, values2, comparator) {
          return array && array.length && values2 && values2.length ? basePullAll(array, values2, undefined$1, comparator) : array;
        }
        var pullAt = flatRest(function(array, indexes) {
          var length = array == null ? 0 : array.length, result2 = baseAt(array, indexes);
          basePullAt(array, arrayMap(indexes, function(index) {
            return isIndex(index, length) ? +index : index;
          }).sort(compareAscending));
          return result2;
        });
        function remove(array, predicate) {
          var result2 = [];
          if (!(array && array.length)) {
            return result2;
          }
          var index = -1, indexes = [], length = array.length;
          predicate = getIteratee(predicate, 3);
          while (++index < length) {
            var value2 = array[index];
            if (predicate(value2, index, array)) {
              result2.push(value2);
              indexes.push(index);
            }
          }
          basePullAt(array, indexes);
          return result2;
        }
        function reverse(array) {
          return array == null ? array : nativeReverse.call(array);
        }
        function slice(array, start, end) {
          var length = array == null ? 0 : array.length;
          if (!length) {
            return [];
          }
          if (end && typeof end != "number" && isIterateeCall(array, start, end)) {
            start = 0;
            end = length;
          } else {
            start = start == null ? 0 : toInteger(start);
            end = end === undefined$1 ? length : toInteger(end);
          }
          return baseSlice(array, start, end);
        }
        function sortedIndex(array, value2) {
          return baseSortedIndex(array, value2);
        }
        function sortedIndexBy(array, value2, iteratee2) {
          return baseSortedIndexBy(array, value2, getIteratee(iteratee2, 2));
        }
        function sortedIndexOf(array, value2) {
          var length = array == null ? 0 : array.length;
          if (length) {
            var index = baseSortedIndex(array, value2);
            if (index < length && eq(array[index], value2)) {
              return index;
            }
          }
          return -1;
        }
        function sortedLastIndex(array, value2) {
          return baseSortedIndex(array, value2, true);
        }
        function sortedLastIndexBy(array, value2, iteratee2) {
          return baseSortedIndexBy(array, value2, getIteratee(iteratee2, 2), true);
        }
        function sortedLastIndexOf(array, value2) {
          var length = array == null ? 0 : array.length;
          if (length) {
            var index = baseSortedIndex(array, value2, true) - 1;
            if (eq(array[index], value2)) {
              return index;
            }
          }
          return -1;
        }
        function sortedUniq(array) {
          return array && array.length ? baseSortedUniq(array) : [];
        }
        function sortedUniqBy(array, iteratee2) {
          return array && array.length ? baseSortedUniq(array, getIteratee(iteratee2, 2)) : [];
        }
        function tail(array) {
          var length = array == null ? 0 : array.length;
          return length ? baseSlice(array, 1, length) : [];
        }
        function take(array, n, guard) {
          if (!(array && array.length)) {
            return [];
          }
          n = guard || n === undefined$1 ? 1 : toInteger(n);
          return baseSlice(array, 0, n < 0 ? 0 : n);
        }
        function takeRight(array, n, guard) {
          var length = array == null ? 0 : array.length;
          if (!length) {
            return [];
          }
          n = guard || n === undefined$1 ? 1 : toInteger(n);
          n = length - n;
          return baseSlice(array, n < 0 ? 0 : n, length);
        }
        function takeRightWhile(array, predicate) {
          return array && array.length ? baseWhile(array, getIteratee(predicate, 3), false, true) : [];
        }
        function takeWhile(array, predicate) {
          return array && array.length ? baseWhile(array, getIteratee(predicate, 3)) : [];
        }
        var union = baseRest(function(arrays) {
          return baseUniq(baseFlatten(arrays, 1, isArrayLikeObject, true));
        });
        var unionBy = baseRest(function(arrays) {
          var iteratee2 = last(arrays);
          if (isArrayLikeObject(iteratee2)) {
            iteratee2 = undefined$1;
          }
          return baseUniq(baseFlatten(arrays, 1, isArrayLikeObject, true), getIteratee(iteratee2, 2));
        });
        var unionWith = baseRest(function(arrays) {
          var comparator = last(arrays);
          comparator = typeof comparator == "function" ? comparator : undefined$1;
          return baseUniq(baseFlatten(arrays, 1, isArrayLikeObject, true), undefined$1, comparator);
        });
        function uniq(array) {
          return array && array.length ? baseUniq(array) : [];
        }
        function uniqBy(array, iteratee2) {
          return array && array.length ? baseUniq(array, getIteratee(iteratee2, 2)) : [];
        }
        function uniqWith(array, comparator) {
          comparator = typeof comparator == "function" ? comparator : undefined$1;
          return array && array.length ? baseUniq(array, undefined$1, comparator) : [];
        }
        function unzip(array) {
          if (!(array && array.length)) {
            return [];
          }
          var length = 0;
          array = arrayFilter(array, function(group) {
            if (isArrayLikeObject(group)) {
              length = nativeMax(group.length, length);
              return true;
            }
          });
          return baseTimes(length, function(index) {
            return arrayMap(array, baseProperty(index));
          });
        }
        function unzipWith(array, iteratee2) {
          if (!(array && array.length)) {
            return [];
          }
          var result2 = unzip(array);
          if (iteratee2 == null) {
            return result2;
          }
          return arrayMap(result2, function(group) {
            return apply(iteratee2, undefined$1, group);
          });
        }
        var without = baseRest(function(array, values2) {
          return isArrayLikeObject(array) ? baseDifference(array, values2) : [];
        });
        var xor = baseRest(function(arrays) {
          return baseXor(arrayFilter(arrays, isArrayLikeObject));
        });
        var xorBy = baseRest(function(arrays) {
          var iteratee2 = last(arrays);
          if (isArrayLikeObject(iteratee2)) {
            iteratee2 = undefined$1;
          }
          return baseXor(arrayFilter(arrays, isArrayLikeObject), getIteratee(iteratee2, 2));
        });
        var xorWith = baseRest(function(arrays) {
          var comparator = last(arrays);
          comparator = typeof comparator == "function" ? comparator : undefined$1;
          return baseXor(arrayFilter(arrays, isArrayLikeObject), undefined$1, comparator);
        });
        var zip = baseRest(unzip);
        function zipObject(props, values2) {
          return baseZipObject(props || [], values2 || [], assignValue);
        }
        function zipObjectDeep(props, values2) {
          return baseZipObject(props || [], values2 || [], baseSet);
        }
        var zipWith = baseRest(function(arrays) {
          var length = arrays.length, iteratee2 = length > 1 ? arrays[length - 1] : undefined$1;
          iteratee2 = typeof iteratee2 == "function" ? (arrays.pop(), iteratee2) : undefined$1;
          return unzipWith(arrays, iteratee2);
        });
        function chain(value2) {
          var result2 = lodash2(value2);
          result2.__chain__ = true;
          return result2;
        }
        function tap(value2, interceptor) {
          interceptor(value2);
          return value2;
        }
        function thru(value2, interceptor) {
          return interceptor(value2);
        }
        var wrapperAt = flatRest(function(paths) {
          var length = paths.length, start = length ? paths[0] : 0, value2 = this.__wrapped__, interceptor = function(object) {
            return baseAt(object, paths);
          };
          if (length > 1 || this.__actions__.length || !(value2 instanceof LazyWrapper) || !isIndex(start)) {
            return this.thru(interceptor);
          }
          value2 = value2.slice(start, +start + (length ? 1 : 0));
          value2.__actions__.push({
            "func": thru,
            "args": [interceptor],
            "thisArg": undefined$1
          });
          return new LodashWrapper(value2, this.__chain__).thru(function(array) {
            if (length && !array.length) {
              array.push(undefined$1);
            }
            return array;
          });
        });
        function wrapperChain() {
          return chain(this);
        }
        function wrapperCommit() {
          return new LodashWrapper(this.value(), this.__chain__);
        }
        function wrapperNext() {
          if (this.__values__ === undefined$1) {
            this.__values__ = toArray(this.value());
          }
          var done = this.__index__ >= this.__values__.length, value2 = done ? undefined$1 : this.__values__[this.__index__++];
          return { "done": done, "value": value2 };
        }
        function wrapperToIterator() {
          return this;
        }
        function wrapperPlant(value2) {
          var result2, parent2 = this;
          while (parent2 instanceof baseLodash) {
            var clone2 = wrapperClone(parent2);
            clone2.__index__ = 0;
            clone2.__values__ = undefined$1;
            if (result2) {
              previous.__wrapped__ = clone2;
            } else {
              result2 = clone2;
            }
            var previous = clone2;
            parent2 = parent2.__wrapped__;
          }
          previous.__wrapped__ = value2;
          return result2;
        }
        function wrapperReverse() {
          var value2 = this.__wrapped__;
          if (value2 instanceof LazyWrapper) {
            var wrapped = value2;
            if (this.__actions__.length) {
              wrapped = new LazyWrapper(this);
            }
            wrapped = wrapped.reverse();
            wrapped.__actions__.push({
              "func": thru,
              "args": [reverse],
              "thisArg": undefined$1
            });
            return new LodashWrapper(wrapped, this.__chain__);
          }
          return this.thru(reverse);
        }
        function wrapperValue() {
          return baseWrapperValue(this.__wrapped__, this.__actions__);
        }
        var countBy = createAggregator(function(result2, value2, key) {
          if (hasOwnProperty.call(result2, key)) {
            ++result2[key];
          } else {
            baseAssignValue(result2, key, 1);
          }
        });
        function every(collection, predicate, guard) {
          var func = isArray(collection) ? arrayEvery : baseEvery;
          if (guard && isIterateeCall(collection, predicate, guard)) {
            predicate = undefined$1;
          }
          return func(collection, getIteratee(predicate, 3));
        }
        function filter(collection, predicate) {
          var func = isArray(collection) ? arrayFilter : baseFilter;
          return func(collection, getIteratee(predicate, 3));
        }
        var find = createFind(findIndex);
        var findLast = createFind(findLastIndex);
        function flatMap(collection, iteratee2) {
          return baseFlatten(map2(collection, iteratee2), 1);
        }
        function flatMapDeep(collection, iteratee2) {
          return baseFlatten(map2(collection, iteratee2), INFINITY);
        }
        function flatMapDepth(collection, iteratee2, depth) {
          depth = depth === undefined$1 ? 1 : toInteger(depth);
          return baseFlatten(map2(collection, iteratee2), depth);
        }
        function forEach(collection, iteratee2) {
          var func = isArray(collection) ? arrayEach : baseEach;
          return func(collection, getIteratee(iteratee2, 3));
        }
        function forEachRight(collection, iteratee2) {
          var func = isArray(collection) ? arrayEachRight : baseEachRight;
          return func(collection, getIteratee(iteratee2, 3));
        }
        var groupBy = createAggregator(function(result2, value2, key) {
          if (hasOwnProperty.call(result2, key)) {
            result2[key].push(value2);
          } else {
            baseAssignValue(result2, key, [value2]);
          }
        });
        function includes(collection, value2, fromIndex, guard) {
          collection = isArrayLike(collection) ? collection : values(collection);
          fromIndex = fromIndex && !guard ? toInteger(fromIndex) : 0;
          var length = collection.length;
          if (fromIndex < 0) {
            fromIndex = nativeMax(length + fromIndex, 0);
          }
          return isString(collection) ? fromIndex <= length && collection.indexOf(value2, fromIndex) > -1 : !!length && baseIndexOf(collection, value2, fromIndex) > -1;
        }
        var invokeMap = baseRest(function(collection, path, args) {
          var index = -1, isFunc = typeof path == "function", result2 = isArrayLike(collection) ? Array2(collection.length) : [];
          baseEach(collection, function(value2) {
            result2[++index] = isFunc ? apply(path, value2, args) : baseInvoke(value2, path, args);
          });
          return result2;
        });
        var keyBy = createAggregator(function(result2, value2, key) {
          baseAssignValue(result2, key, value2);
        });
        function map2(collection, iteratee2) {
          var func = isArray(collection) ? arrayMap : baseMap;
          return func(collection, getIteratee(iteratee2, 3));
        }
        function orderBy(collection, iteratees, orders, guard) {
          if (collection == null) {
            return [];
          }
          if (!isArray(iteratees)) {
            iteratees = iteratees == null ? [] : [iteratees];
          }
          orders = guard ? undefined$1 : orders;
          if (!isArray(orders)) {
            orders = orders == null ? [] : [orders];
          }
          return baseOrderBy(collection, iteratees, orders);
        }
        var partition = createAggregator(function(result2, value2, key) {
          result2[key ? 0 : 1].push(value2);
        }, function() {
          return [[], []];
        });
        function reduce(collection, iteratee2, accumulator) {
          var func = isArray(collection) ? arrayReduce : baseReduce, initAccum = arguments.length < 3;
          return func(collection, getIteratee(iteratee2, 4), accumulator, initAccum, baseEach);
        }
        function reduceRight(collection, iteratee2, accumulator) {
          var func = isArray(collection) ? arrayReduceRight : baseReduce, initAccum = arguments.length < 3;
          return func(collection, getIteratee(iteratee2, 4), accumulator, initAccum, baseEachRight);
        }
        function reject(collection, predicate) {
          var func = isArray(collection) ? arrayFilter : baseFilter;
          return func(collection, negate(getIteratee(predicate, 3)));
        }
        function sample(collection) {
          var func = isArray(collection) ? arraySample : baseSample;
          return func(collection);
        }
        function sampleSize(collection, n, guard) {
          if (guard ? isIterateeCall(collection, n, guard) : n === undefined$1) {
            n = 1;
          } else {
            n = toInteger(n);
          }
          var func = isArray(collection) ? arraySampleSize : baseSampleSize;
          return func(collection, n);
        }
        function shuffle(collection) {
          var func = isArray(collection) ? arrayShuffle : baseShuffle;
          return func(collection);
        }
        function size(collection) {
          if (collection == null) {
            return 0;
          }
          if (isArrayLike(collection)) {
            return isString(collection) ? stringSize(collection) : collection.length;
          }
          var tag = getTag(collection);
          if (tag == mapTag || tag == setTag) {
            return collection.size;
          }
          return baseKeys(collection).length;
        }
        function some(collection, predicate, guard) {
          var func = isArray(collection) ? arraySome : baseSome;
          if (guard && isIterateeCall(collection, predicate, guard)) {
            predicate = undefined$1;
          }
          return func(collection, getIteratee(predicate, 3));
        }
        var sortBy = baseRest(function(collection, iteratees) {
          if (collection == null) {
            return [];
          }
          var length = iteratees.length;
          if (length > 1 && isIterateeCall(collection, iteratees[0], iteratees[1])) {
            iteratees = [];
          } else if (length > 2 && isIterateeCall(iteratees[0], iteratees[1], iteratees[2])) {
            iteratees = [iteratees[0]];
          }
          return baseOrderBy(collection, baseFlatten(iteratees, 1), []);
        });
        var now2 = ctxNow || function() {
          return root.Date.now();
        };
        function after(n, func) {
          if (typeof func != "function") {
            throw new TypeError2(FUNC_ERROR_TEXT);
          }
          n = toInteger(n);
          return function() {
            if (--n < 1) {
              return func.apply(this, arguments);
            }
          };
        }
        function ary(func, n, guard) {
          n = guard ? undefined$1 : n;
          n = func && n == null ? func.length : n;
          return createWrap(func, WRAP_ARY_FLAG, undefined$1, undefined$1, undefined$1, undefined$1, n);
        }
        function before(n, func) {
          var result2;
          if (typeof func != "function") {
            throw new TypeError2(FUNC_ERROR_TEXT);
          }
          n = toInteger(n);
          return function() {
            if (--n > 0) {
              result2 = func.apply(this, arguments);
            }
            if (n <= 1) {
              func = undefined$1;
            }
            return result2;
          };
        }
        var bind = baseRest(function(func, thisArg, partials) {
          var bitmask = WRAP_BIND_FLAG;
          if (partials.length) {
            var holders = replaceHolders(partials, getHolder(bind));
            bitmask |= WRAP_PARTIAL_FLAG;
          }
          return createWrap(func, bitmask, thisArg, partials, holders);
        });
        var bindKey = baseRest(function(object, key, partials) {
          var bitmask = WRAP_BIND_FLAG | WRAP_BIND_KEY_FLAG;
          if (partials.length) {
            var holders = replaceHolders(partials, getHolder(bindKey));
            bitmask |= WRAP_PARTIAL_FLAG;
          }
          return createWrap(key, bitmask, object, partials, holders);
        });
        function curry(func, arity, guard) {
          arity = guard ? undefined$1 : arity;
          var result2 = createWrap(func, WRAP_CURRY_FLAG, undefined$1, undefined$1, undefined$1, undefined$1, undefined$1, arity);
          result2.placeholder = curry.placeholder;
          return result2;
        }
        function curryRight(func, arity, guard) {
          arity = guard ? undefined$1 : arity;
          var result2 = createWrap(func, WRAP_CURRY_RIGHT_FLAG, undefined$1, undefined$1, undefined$1, undefined$1, undefined$1, arity);
          result2.placeholder = curryRight.placeholder;
          return result2;
        }
        function debounce(func, wait, options) {
          var lastArgs, lastThis, maxWait, result2, timerId, lastCallTime, lastInvokeTime = 0, leading = false, maxing = false, trailing = true;
          if (typeof func != "function") {
            throw new TypeError2(FUNC_ERROR_TEXT);
          }
          wait = toNumber(wait) || 0;
          if (isObject2(options)) {
            leading = !!options.leading;
            maxing = "maxWait" in options;
            maxWait = maxing ? nativeMax(toNumber(options.maxWait) || 0, wait) : maxWait;
            trailing = "trailing" in options ? !!options.trailing : trailing;
          }
          function invokeFunc(time) {
            var args = lastArgs, thisArg = lastThis;
            lastArgs = lastThis = undefined$1;
            lastInvokeTime = time;
            result2 = func.apply(thisArg, args);
            return result2;
          }
          function leadingEdge(time) {
            lastInvokeTime = time;
            timerId = setTimeout(timerExpired, wait);
            return leading ? invokeFunc(time) : result2;
          }
          function remainingWait(time) {
            var timeSinceLastCall = time - lastCallTime, timeSinceLastInvoke = time - lastInvokeTime, timeWaiting = wait - timeSinceLastCall;
            return maxing ? nativeMin(timeWaiting, maxWait - timeSinceLastInvoke) : timeWaiting;
          }
          function shouldInvoke(time) {
            var timeSinceLastCall = time - lastCallTime, timeSinceLastInvoke = time - lastInvokeTime;
            return lastCallTime === undefined$1 || timeSinceLastCall >= wait || timeSinceLastCall < 0 || maxing && timeSinceLastInvoke >= maxWait;
          }
          function timerExpired() {
            var time = now2();
            if (shouldInvoke(time)) {
              return trailingEdge(time);
            }
            timerId = setTimeout(timerExpired, remainingWait(time));
          }
          function trailingEdge(time) {
            timerId = undefined$1;
            if (trailing && lastArgs) {
              return invokeFunc(time);
            }
            lastArgs = lastThis = undefined$1;
            return result2;
          }
          function cancel() {
            if (timerId !== undefined$1) {
              clearTimeout(timerId);
            }
            lastInvokeTime = 0;
            lastArgs = lastCallTime = lastThis = timerId = undefined$1;
          }
          function flush() {
            return timerId === undefined$1 ? result2 : trailingEdge(now2());
          }
          function debounced() {
            var time = now2(), isInvoking = shouldInvoke(time);
            lastArgs = arguments;
            lastThis = this;
            lastCallTime = time;
            if (isInvoking) {
              if (timerId === undefined$1) {
                return leadingEdge(lastCallTime);
              }
              if (maxing) {
                clearTimeout(timerId);
                timerId = setTimeout(timerExpired, wait);
                return invokeFunc(lastCallTime);
              }
            }
            if (timerId === undefined$1) {
              timerId = setTimeout(timerExpired, wait);
            }
            return result2;
          }
          debounced.cancel = cancel;
          debounced.flush = flush;
          return debounced;
        }
        var defer = baseRest(function(func, args) {
          return baseDelay(func, 1, args);
        });
        var delay = baseRest(function(func, wait, args) {
          return baseDelay(func, toNumber(wait) || 0, args);
        });
        function flip(func) {
          return createWrap(func, WRAP_FLIP_FLAG);
        }
        function memoize2(func, resolver) {
          if (typeof func != "function" || resolver != null && typeof resolver != "function") {
            throw new TypeError2(FUNC_ERROR_TEXT);
          }
          var memoized = function() {
            var args = arguments, key = resolver ? resolver.apply(this, args) : args[0], cache = memoized.cache;
            if (cache.has(key)) {
              return cache.get(key);
            }
            var result2 = func.apply(this, args);
            memoized.cache = cache.set(key, result2) || cache;
            return result2;
          };
          memoized.cache = new (memoize2.Cache || MapCache)();
          return memoized;
        }
        memoize2.Cache = MapCache;
        function negate(predicate) {
          if (typeof predicate != "function") {
            throw new TypeError2(FUNC_ERROR_TEXT);
          }
          return function() {
            var args = arguments;
            switch (args.length) {
              case 0:
                return !predicate.call(this);
              case 1:
                return !predicate.call(this, args[0]);
              case 2:
                return !predicate.call(this, args[0], args[1]);
              case 3:
                return !predicate.call(this, args[0], args[1], args[2]);
            }
            return !predicate.apply(this, args);
          };
        }
        function once(func) {
          return before(2, func);
        }
        var overArgs = castRest(function(func, transforms) {
          transforms = transforms.length == 1 && isArray(transforms[0]) ? arrayMap(transforms[0], baseUnary(getIteratee())) : arrayMap(baseFlatten(transforms, 1), baseUnary(getIteratee()));
          var funcsLength = transforms.length;
          return baseRest(function(args) {
            var index = -1, length = nativeMin(args.length, funcsLength);
            while (++index < length) {
              args[index] = transforms[index].call(this, args[index]);
            }
            return apply(func, this, args);
          });
        });
        var partial = baseRest(function(func, partials) {
          var holders = replaceHolders(partials, getHolder(partial));
          return createWrap(func, WRAP_PARTIAL_FLAG, undefined$1, partials, holders);
        });
        var partialRight = baseRest(function(func, partials) {
          var holders = replaceHolders(partials, getHolder(partialRight));
          return createWrap(func, WRAP_PARTIAL_RIGHT_FLAG, undefined$1, partials, holders);
        });
        var rearg = flatRest(function(func, indexes) {
          return createWrap(func, WRAP_REARG_FLAG, undefined$1, undefined$1, undefined$1, indexes);
        });
        function rest(func, start) {
          if (typeof func != "function") {
            throw new TypeError2(FUNC_ERROR_TEXT);
          }
          start = start === undefined$1 ? start : toInteger(start);
          return baseRest(func, start);
        }
        function spread(func, start) {
          if (typeof func != "function") {
            throw new TypeError2(FUNC_ERROR_TEXT);
          }
          start = start == null ? 0 : nativeMax(toInteger(start), 0);
          return baseRest(function(args) {
            var array = args[start], otherArgs = castSlice(args, 0, start);
            if (array) {
              arrayPush(otherArgs, array);
            }
            return apply(func, this, otherArgs);
          });
        }
        function throttle(func, wait, options) {
          var leading = true, trailing = true;
          if (typeof func != "function") {
            throw new TypeError2(FUNC_ERROR_TEXT);
          }
          if (isObject2(options)) {
            leading = "leading" in options ? !!options.leading : leading;
            trailing = "trailing" in options ? !!options.trailing : trailing;
          }
          return debounce(func, wait, {
            "leading": leading,
            "maxWait": wait,
            "trailing": trailing
          });
        }
        function unary(func) {
          return ary(func, 1);
        }
        function wrap(value2, wrapper) {
          return partial(castFunction(wrapper), value2);
        }
        function castArray() {
          if (!arguments.length) {
            return [];
          }
          var value2 = arguments[0];
          return isArray(value2) ? value2 : [value2];
        }
        function clone(value2) {
          return baseClone(value2, CLONE_SYMBOLS_FLAG);
        }
        function cloneWith(value2, customizer) {
          customizer = typeof customizer == "function" ? customizer : undefined$1;
          return baseClone(value2, CLONE_SYMBOLS_FLAG, customizer);
        }
        function cloneDeep(value2) {
          return baseClone(value2, CLONE_DEEP_FLAG | CLONE_SYMBOLS_FLAG);
        }
        function cloneDeepWith(value2, customizer) {
          customizer = typeof customizer == "function" ? customizer : undefined$1;
          return baseClone(value2, CLONE_DEEP_FLAG | CLONE_SYMBOLS_FLAG, customizer);
        }
        function conformsTo(object, source) {
          return source == null || baseConformsTo(object, source, keys(source));
        }
        function eq(value2, other) {
          return value2 === other || value2 !== value2 && other !== other;
        }
        var gt = createRelationalOperation(baseGt);
        var gte = createRelationalOperation(function(value2, other) {
          return value2 >= other;
        });
        var isArguments = baseIsArguments(/* @__PURE__ */ function() {
          return arguments;
        }()) ? baseIsArguments : function(value2) {
          return isObjectLike(value2) && hasOwnProperty.call(value2, "callee") && !propertyIsEnumerable.call(value2, "callee");
        };
        var isArray = Array2.isArray;
        var isArrayBuffer = nodeIsArrayBuffer ? baseUnary(nodeIsArrayBuffer) : baseIsArrayBuffer;
        function isArrayLike(value2) {
          return value2 != null && isLength(value2.length) && !isFunction(value2);
        }
        function isArrayLikeObject(value2) {
          return isObjectLike(value2) && isArrayLike(value2);
        }
        function isBoolean(value2) {
          return value2 === true || value2 === false || isObjectLike(value2) && baseGetTag(value2) == boolTag;
        }
        var isBuffer = nativeIsBuffer || stubFalse;
        var isDate = nodeIsDate ? baseUnary(nodeIsDate) : baseIsDate;
        function isElement(value2) {
          return isObjectLike(value2) && value2.nodeType === 1 && !isPlainObject(value2);
        }
        function isEmpty(value2) {
          if (value2 == null) {
            return true;
          }
          if (isArrayLike(value2) && (isArray(value2) || typeof value2 == "string" || typeof value2.splice == "function" || isBuffer(value2) || isTypedArray(value2) || isArguments(value2))) {
            return !value2.length;
          }
          var tag = getTag(value2);
          if (tag == mapTag || tag == setTag) {
            return !value2.size;
          }
          if (isPrototype(value2)) {
            return !baseKeys(value2).length;
          }
          for (var key in value2) {
            if (hasOwnProperty.call(value2, key)) {
              return false;
            }
          }
          return true;
        }
        function isEqual(value2, other) {
          return baseIsEqual(value2, other);
        }
        function isEqualWith(value2, other, customizer) {
          customizer = typeof customizer == "function" ? customizer : undefined$1;
          var result2 = customizer ? customizer(value2, other) : undefined$1;
          return result2 === undefined$1 ? baseIsEqual(value2, other, undefined$1, customizer) : !!result2;
        }
        function isError(value2) {
          if (!isObjectLike(value2)) {
            return false;
          }
          var tag = baseGetTag(value2);
          return tag == errorTag || tag == domExcTag || typeof value2.message == "string" && typeof value2.name == "string" && !isPlainObject(value2);
        }
        function isFinite2(value2) {
          return typeof value2 == "number" && nativeIsFinite(value2);
        }
        function isFunction(value2) {
          if (!isObject2(value2)) {
            return false;
          }
          var tag = baseGetTag(value2);
          return tag == funcTag || tag == genTag || tag == asyncTag || tag == proxyTag;
        }
        function isInteger2(value2) {
          return typeof value2 == "number" && value2 == toInteger(value2);
        }
        function isLength(value2) {
          return typeof value2 == "number" && value2 > -1 && value2 % 1 == 0 && value2 <= MAX_SAFE_INTEGER;
        }
        function isObject2(value2) {
          var type = typeof value2;
          return value2 != null && (type == "object" || type == "function");
        }
        function isObjectLike(value2) {
          return value2 != null && typeof value2 == "object";
        }
        var isMap = nodeIsMap ? baseUnary(nodeIsMap) : baseIsMap;
        function isMatch(object, source) {
          return object === source || baseIsMatch(object, source, getMatchData(source));
        }
        function isMatchWith(object, source, customizer) {
          customizer = typeof customizer == "function" ? customizer : undefined$1;
          return baseIsMatch(object, source, getMatchData(source), customizer);
        }
        function isNaN(value2) {
          return isNumber2(value2) && value2 != +value2;
        }
        function isNative(value2) {
          if (isMaskable(value2)) {
            throw new Error2(CORE_ERROR_TEXT);
          }
          return baseIsNative(value2);
        }
        function isNull(value2) {
          return value2 === null;
        }
        function isNil(value2) {
          return value2 == null;
        }
        function isNumber2(value2) {
          return typeof value2 == "number" || isObjectLike(value2) && baseGetTag(value2) == numberTag;
        }
        function isPlainObject(value2) {
          if (!isObjectLike(value2) || baseGetTag(value2) != objectTag) {
            return false;
          }
          var proto = getPrototype(value2);
          if (proto === null) {
            return true;
          }
          var Ctor = hasOwnProperty.call(proto, "constructor") && proto.constructor;
          return typeof Ctor == "function" && Ctor instanceof Ctor && funcToString.call(Ctor) == objectCtorString;
        }
        var isRegExp = nodeIsRegExp ? baseUnary(nodeIsRegExp) : baseIsRegExp;
        function isSafeInteger2(value2) {
          return isInteger2(value2) && value2 >= -MAX_SAFE_INTEGER && value2 <= MAX_SAFE_INTEGER;
        }
        var isSet = nodeIsSet ? baseUnary(nodeIsSet) : baseIsSet;
        function isString(value2) {
          return typeof value2 == "string" || !isArray(value2) && isObjectLike(value2) && baseGetTag(value2) == stringTag;
        }
        function isSymbol(value2) {
          return typeof value2 == "symbol" || isObjectLike(value2) && baseGetTag(value2) == symbolTag;
        }
        var isTypedArray = nodeIsTypedArray ? baseUnary(nodeIsTypedArray) : baseIsTypedArray;
        function isUndefined(value2) {
          return value2 === undefined$1;
        }
        function isWeakMap(value2) {
          return isObjectLike(value2) && getTag(value2) == weakMapTag;
        }
        function isWeakSet(value2) {
          return isObjectLike(value2) && baseGetTag(value2) == weakSetTag;
        }
        var lt = createRelationalOperation(baseLt);
        var lte = createRelationalOperation(function(value2, other) {
          return value2 <= other;
        });
        function toArray(value2) {
          if (!value2) {
            return [];
          }
          if (isArrayLike(value2)) {
            return isString(value2) ? stringToArray(value2) : copyArray(value2);
          }
          if (symIterator && value2[symIterator]) {
            return iteratorToArray(value2[symIterator]());
          }
          var tag = getTag(value2), func = tag == mapTag ? mapToArray : tag == setTag ? setToArray : values;
          return func(value2);
        }
        function toFinite(value2) {
          if (!value2) {
            return value2 === 0 ? value2 : 0;
          }
          value2 = toNumber(value2);
          if (value2 === INFINITY || value2 === -INFINITY) {
            var sign = value2 < 0 ? -1 : 1;
            return sign * MAX_INTEGER;
          }
          return value2 === value2 ? value2 : 0;
        }
        function toInteger(value2) {
          var result2 = toFinite(value2), remainder = result2 % 1;
          return result2 === result2 ? remainder ? result2 - remainder : result2 : 0;
        }
        function toLength(value2) {
          return value2 ? baseClamp(toInteger(value2), 0, MAX_ARRAY_LENGTH) : 0;
        }
        function toNumber(value2) {
          if (typeof value2 == "number") {
            return value2;
          }
          if (isSymbol(value2)) {
            return NAN;
          }
          if (isObject2(value2)) {
            var other = typeof value2.valueOf == "function" ? value2.valueOf() : value2;
            value2 = isObject2(other) ? other + "" : other;
          }
          if (typeof value2 != "string") {
            return value2 === 0 ? value2 : +value2;
          }
          value2 = baseTrim(value2);
          var isBinary = reIsBinary.test(value2);
          return isBinary || reIsOctal.test(value2) ? freeParseInt(value2.slice(2), isBinary ? 2 : 8) : reIsBadHex.test(value2) ? NAN : +value2;
        }
        function toPlainObject(value2) {
          return copyObject(value2, keysIn(value2));
        }
        function toSafeInteger(value2) {
          return value2 ? baseClamp(toInteger(value2), -MAX_SAFE_INTEGER, MAX_SAFE_INTEGER) : value2 === 0 ? value2 : 0;
        }
        function toString2(value2) {
          return value2 == null ? "" : baseToString(value2);
        }
        var assign = createAssigner(function(object, source) {
          if (isPrototype(source) || isArrayLike(source)) {
            copyObject(source, keys(source), object);
            return;
          }
          for (var key in source) {
            if (hasOwnProperty.call(source, key)) {
              assignValue(object, key, source[key]);
            }
          }
        });
        var assignIn = createAssigner(function(object, source) {
          copyObject(source, keysIn(source), object);
        });
        var assignInWith = createAssigner(function(object, source, srcIndex, customizer) {
          copyObject(source, keysIn(source), object, customizer);
        });
        var assignWith = createAssigner(function(object, source, srcIndex, customizer) {
          copyObject(source, keys(source), object, customizer);
        });
        var at = flatRest(baseAt);
        function create(prototype, properties) {
          var result2 = baseCreate(prototype);
          return properties == null ? result2 : baseAssign(result2, properties);
        }
        var defaults = baseRest(function(object, sources) {
          object = Object2(object);
          var index = -1;
          var length = sources.length;
          var guard = length > 2 ? sources[2] : undefined$1;
          if (guard && isIterateeCall(sources[0], sources[1], guard)) {
            length = 1;
          }
          while (++index < length) {
            var source = sources[index];
            var props = keysIn(source);
            var propsIndex = -1;
            var propsLength = props.length;
            while (++propsIndex < propsLength) {
              var key = props[propsIndex];
              var value2 = object[key];
              if (value2 === undefined$1 || eq(value2, objectProto[key]) && !hasOwnProperty.call(object, key)) {
                object[key] = source[key];
              }
            }
          }
          return object;
        });
        var defaultsDeep = baseRest(function(args) {
          args.push(undefined$1, customDefaultsMerge);
          return apply(mergeWith, undefined$1, args);
        });
        function findKey(object, predicate) {
          return baseFindKey(object, getIteratee(predicate, 3), baseForOwn);
        }
        function findLastKey(object, predicate) {
          return baseFindKey(object, getIteratee(predicate, 3), baseForOwnRight);
        }
        function forIn(object, iteratee2) {
          return object == null ? object : baseFor(object, getIteratee(iteratee2, 3), keysIn);
        }
        function forInRight(object, iteratee2) {
          return object == null ? object : baseForRight(object, getIteratee(iteratee2, 3), keysIn);
        }
        function forOwn(object, iteratee2) {
          return object && baseForOwn(object, getIteratee(iteratee2, 3));
        }
        function forOwnRight(object, iteratee2) {
          return object && baseForOwnRight(object, getIteratee(iteratee2, 3));
        }
        function functions(object) {
          return object == null ? [] : baseFunctions(object, keys(object));
        }
        function functionsIn(object) {
          return object == null ? [] : baseFunctions(object, keysIn(object));
        }
        function get(object, path, defaultValue) {
          var result2 = object == null ? undefined$1 : baseGet(object, path);
          return result2 === undefined$1 ? defaultValue : result2;
        }
        function has(object, path) {
          return object != null && hasPath(object, path, baseHas);
        }
        function hasIn(object, path) {
          return object != null && hasPath(object, path, baseHasIn);
        }
        var invert = createInverter(function(result2, value2, key) {
          if (value2 != null && typeof value2.toString != "function") {
            value2 = nativeObjectToString.call(value2);
          }
          result2[value2] = key;
        }, constant(identity));
        var invertBy = createInverter(function(result2, value2, key) {
          if (value2 != null && typeof value2.toString != "function") {
            value2 = nativeObjectToString.call(value2);
          }
          if (hasOwnProperty.call(result2, value2)) {
            result2[value2].push(key);
          } else {
            result2[value2] = [key];
          }
        }, getIteratee);
        var invoke = baseRest(baseInvoke);
        function keys(object) {
          return isArrayLike(object) ? arrayLikeKeys(object) : baseKeys(object);
        }
        function keysIn(object) {
          return isArrayLike(object) ? arrayLikeKeys(object, true) : baseKeysIn(object);
        }
        function mapKeys(object, iteratee2) {
          var result2 = {};
          iteratee2 = getIteratee(iteratee2, 3);
          baseForOwn(object, function(value2, key, object2) {
            baseAssignValue(result2, iteratee2(value2, key, object2), value2);
          });
          return result2;
        }
        function mapValues(object, iteratee2) {
          var result2 = {};
          iteratee2 = getIteratee(iteratee2, 3);
          baseForOwn(object, function(value2, key, object2) {
            baseAssignValue(result2, key, iteratee2(value2, key, object2));
          });
          return result2;
        }
        var merge = createAssigner(function(object, source, srcIndex) {
          baseMerge(object, source, srcIndex);
        });
        var mergeWith = createAssigner(function(object, source, srcIndex, customizer) {
          baseMerge(object, source, srcIndex, customizer);
        });
        var omit = flatRest(function(object, paths) {
          var result2 = {};
          if (object == null) {
            return result2;
          }
          var isDeep = false;
          paths = arrayMap(paths, function(path) {
            path = castPath(path, object);
            isDeep || (isDeep = path.length > 1);
            return path;
          });
          copyObject(object, getAllKeysIn(object), result2);
          if (isDeep) {
            result2 = baseClone(result2, CLONE_DEEP_FLAG | CLONE_FLAT_FLAG | CLONE_SYMBOLS_FLAG, customOmitClone);
          }
          var length = paths.length;
          while (length--) {
            baseUnset(result2, paths[length]);
          }
          return result2;
        });
        function omitBy(object, predicate) {
          return pickBy(object, negate(getIteratee(predicate)));
        }
        var pick = flatRest(function(object, paths) {
          return object == null ? {} : basePick(object, paths);
        });
        function pickBy(object, predicate) {
          if (object == null) {
            return {};
          }
          var props = arrayMap(getAllKeysIn(object), function(prop) {
            return [prop];
          });
          predicate = getIteratee(predicate);
          return basePickBy(object, props, function(value2, path) {
            return predicate(value2, path[0]);
          });
        }
        function result(object, path, defaultValue) {
          path = castPath(path, object);
          var index = -1, length = path.length;
          if (!length) {
            length = 1;
            object = undefined$1;
          }
          while (++index < length) {
            var value2 = object == null ? undefined$1 : object[toKey(path[index])];
            if (value2 === undefined$1) {
              index = length;
              value2 = defaultValue;
            }
            object = isFunction(value2) ? value2.call(object) : value2;
          }
          return object;
        }
        function set(object, path, value2) {
          return object == null ? object : baseSet(object, path, value2);
        }
        function setWith(object, path, value2, customizer) {
          customizer = typeof customizer == "function" ? customizer : undefined$1;
          return object == null ? object : baseSet(object, path, value2, customizer);
        }
        var toPairs = createToPairs(keys);
        var toPairsIn = createToPairs(keysIn);
        function transform(object, iteratee2, accumulator) {
          var isArr = isArray(object), isArrLike = isArr || isBuffer(object) || isTypedArray(object);
          iteratee2 = getIteratee(iteratee2, 4);
          if (accumulator == null) {
            var Ctor = object && object.constructor;
            if (isArrLike) {
              accumulator = isArr ? new Ctor() : [];
            } else if (isObject2(object)) {
              accumulator = isFunction(Ctor) ? baseCreate(getPrototype(object)) : {};
            } else {
              accumulator = {};
            }
          }
          (isArrLike ? arrayEach : baseForOwn)(object, function(value2, index, object2) {
            return iteratee2(accumulator, value2, index, object2);
          });
          return accumulator;
        }
        function unset(object, path) {
          return object == null ? true : baseUnset(object, path);
        }
        function update(object, path, updater) {
          return object == null ? object : baseUpdate(object, path, castFunction(updater));
        }
        function updateWith(object, path, updater, customizer) {
          customizer = typeof customizer == "function" ? customizer : undefined$1;
          return object == null ? object : baseUpdate(object, path, castFunction(updater), customizer);
        }
        function values(object) {
          return object == null ? [] : baseValues(object, keys(object));
        }
        function valuesIn(object) {
          return object == null ? [] : baseValues(object, keysIn(object));
        }
        function clamp(number, lower, upper) {
          if (upper === undefined$1) {
            upper = lower;
            lower = undefined$1;
          }
          if (upper !== undefined$1) {
            upper = toNumber(upper);
            upper = upper === upper ? upper : 0;
          }
          if (lower !== undefined$1) {
            lower = toNumber(lower);
            lower = lower === lower ? lower : 0;
          }
          return baseClamp(toNumber(number), lower, upper);
        }
        function inRange(number, start, end) {
          start = toFinite(start);
          if (end === undefined$1) {
            end = start;
            start = 0;
          } else {
            end = toFinite(end);
          }
          number = toNumber(number);
          return baseInRange(number, start, end);
        }
        function random(lower, upper, floating) {
          if (floating && typeof floating != "boolean" && isIterateeCall(lower, upper, floating)) {
            upper = floating = undefined$1;
          }
          if (floating === undefined$1) {
            if (typeof upper == "boolean") {
              floating = upper;
              upper = undefined$1;
            } else if (typeof lower == "boolean") {
              floating = lower;
              lower = undefined$1;
            }
          }
          if (lower === undefined$1 && upper === undefined$1) {
            lower = 0;
            upper = 1;
          } else {
            lower = toFinite(lower);
            if (upper === undefined$1) {
              upper = lower;
              lower = 0;
            } else {
              upper = toFinite(upper);
            }
          }
          if (lower > upper) {
            var temp = lower;
            lower = upper;
            upper = temp;
          }
          if (floating || lower % 1 || upper % 1) {
            var rand = nativeRandom();
            return nativeMin(lower + rand * (upper - lower + freeParseFloat("1e-" + ((rand + "").length - 1))), upper);
          }
          return baseRandom(lower, upper);
        }
        var camelCase = createCompounder(function(result2, word, index) {
          word = word.toLowerCase();
          return result2 + (index ? capitalize(word) : word);
        });
        function capitalize(string2) {
          return upperFirst(toString2(string2).toLowerCase());
        }
        function deburr(string2) {
          string2 = toString2(string2);
          return string2 && string2.replace(reLatin, deburrLetter).replace(reComboMark, "");
        }
        function endsWith(string2, target, position) {
          string2 = toString2(string2);
          target = baseToString(target);
          var length = string2.length;
          position = position === undefined$1 ? length : baseClamp(toInteger(position), 0, length);
          var end = position;
          position -= target.length;
          return position >= 0 && string2.slice(position, end) == target;
        }
        function escape(string2) {
          string2 = toString2(string2);
          return string2 && reHasUnescapedHtml.test(string2) ? string2.replace(reUnescapedHtml, escapeHtmlChar) : string2;
        }
        function escapeRegExp(string2) {
          string2 = toString2(string2);
          return string2 && reHasRegExpChar.test(string2) ? string2.replace(reRegExpChar, "\\$&") : string2;
        }
        var kebabCase = createCompounder(function(result2, word, index) {
          return result2 + (index ? "-" : "") + word.toLowerCase();
        });
        var lowerCase = createCompounder(function(result2, word, index) {
          return result2 + (index ? " " : "") + word.toLowerCase();
        });
        var lowerFirst = createCaseFirst("toLowerCase");
        function pad(string2, length, chars) {
          string2 = toString2(string2);
          length = toInteger(length);
          var strLength = length ? stringSize(string2) : 0;
          if (!length || strLength >= length) {
            return string2;
          }
          var mid = (length - strLength) / 2;
          return createPadding(nativeFloor(mid), chars) + string2 + createPadding(nativeCeil(mid), chars);
        }
        function padEnd(string2, length, chars) {
          string2 = toString2(string2);
          length = toInteger(length);
          var strLength = length ? stringSize(string2) : 0;
          return length && strLength < length ? string2 + createPadding(length - strLength, chars) : string2;
        }
        function padStart(string2, length, chars) {
          string2 = toString2(string2);
          length = toInteger(length);
          var strLength = length ? stringSize(string2) : 0;
          return length && strLength < length ? createPadding(length - strLength, chars) + string2 : string2;
        }
        function parseInt2(string2, radix, guard) {
          if (guard || radix == null) {
            radix = 0;
          } else if (radix) {
            radix = +radix;
          }
          return nativeParseInt(toString2(string2).replace(reTrimStart, ""), radix || 0);
        }
        function repeat(string2, n, guard) {
          if (guard ? isIterateeCall(string2, n, guard) : n === undefined$1) {
            n = 1;
          } else {
            n = toInteger(n);
          }
          return baseRepeat(toString2(string2), n);
        }
        function replace() {
          var args = arguments, string2 = toString2(args[0]);
          return args.length < 3 ? string2 : string2.replace(args[1], args[2]);
        }
        var snakeCase = createCompounder(function(result2, word, index) {
          return result2 + (index ? "_" : "") + word.toLowerCase();
        });
        function split(string2, separator, limit) {
          if (limit && typeof limit != "number" && isIterateeCall(string2, separator, limit)) {
            separator = limit = undefined$1;
          }
          limit = limit === undefined$1 ? MAX_ARRAY_LENGTH : limit >>> 0;
          if (!limit) {
            return [];
          }
          string2 = toString2(string2);
          if (string2 && (typeof separator == "string" || separator != null && !isRegExp(separator))) {
            separator = baseToString(separator);
            if (!separator && hasUnicode(string2)) {
              return castSlice(stringToArray(string2), 0, limit);
            }
          }
          return string2.split(separator, limit);
        }
        var startCase = createCompounder(function(result2, word, index) {
          return result2 + (index ? " " : "") + upperFirst(word);
        });
        function startsWith2(string2, target, position) {
          string2 = toString2(string2);
          position = position == null ? 0 : baseClamp(toInteger(position), 0, string2.length);
          target = baseToString(target);
          return string2.slice(position, position + target.length) == target;
        }
        function template(string2, options, guard) {
          var settings = lodash2.templateSettings;
          if (guard && isIterateeCall(string2, options, guard)) {
            options = undefined$1;
          }
          string2 = toString2(string2);
          options = assignInWith({}, options, settings, customDefaultsAssignIn);
          var imports = assignInWith({}, options.imports, settings.imports, customDefaultsAssignIn), importsKeys = keys(imports), importsValues = baseValues(imports, importsKeys);
          var isEscaping, isEvaluating, index = 0, interpolate = options.interpolate || reNoMatch, source = "__p += '";
          var reDelimiters = RegExp2(
            (options.escape || reNoMatch).source + "|" + interpolate.source + "|" + (interpolate === reInterpolate ? reEsTemplate : reNoMatch).source + "|" + (options.evaluate || reNoMatch).source + "|$",
            "g"
          );
          var sourceURL = "//# sourceURL=" + (hasOwnProperty.call(options, "sourceURL") ? (options.sourceURL + "").replace(/\s/g, " ") : "lodash.templateSources[" + ++templateCounter + "]") + "\n";
          string2.replace(reDelimiters, function(match, escapeValue, interpolateValue, esTemplateValue, evaluateValue, offset) {
            interpolateValue || (interpolateValue = esTemplateValue);
            source += string2.slice(index, offset).replace(reUnescapedString, escapeStringChar);
            if (escapeValue) {
              isEscaping = true;
              source += "' +\n__e(" + escapeValue + ") +\n'";
            }
            if (evaluateValue) {
              isEvaluating = true;
              source += "';\n" + evaluateValue + ";\n__p += '";
            }
            if (interpolateValue) {
              source += "' +\n((__t = (" + interpolateValue + ")) == null ? '' : __t) +\n'";
            }
            index = offset + match.length;
            return match;
          });
          source += "';\n";
          var variable = hasOwnProperty.call(options, "variable") && options.variable;
          if (!variable) {
            source = "with (obj) {\n" + source + "\n}\n";
          } else if (reForbiddenIdentifierChars.test(variable)) {
            throw new Error2(INVALID_TEMPL_VAR_ERROR_TEXT);
          }
          source = (isEvaluating ? source.replace(reEmptyStringLeading, "") : source).replace(reEmptyStringMiddle, "$1").replace(reEmptyStringTrailing, "$1;");
          source = "function(" + (variable || "obj") + ") {\n" + (variable ? "" : "obj || (obj = {});\n") + "var __t, __p = ''" + (isEscaping ? ", __e = _.escape" : "") + (isEvaluating ? ", __j = Array.prototype.join;\nfunction print() { __p += __j.call(arguments, '') }\n" : ";\n") + source + "return __p\n}";
          var result2 = attempt(function() {
            return Function2(importsKeys, sourceURL + "return " + source).apply(undefined$1, importsValues);
          });
          result2.source = source;
          if (isError(result2)) {
            throw result2;
          }
          return result2;
        }
        function toLower(value2) {
          return toString2(value2).toLowerCase();
        }
        function toUpper(value2) {
          return toString2(value2).toUpperCase();
        }
        function trim(string2, chars, guard) {
          string2 = toString2(string2);
          if (string2 && (guard || chars === undefined$1)) {
            return baseTrim(string2);
          }
          if (!string2 || !(chars = baseToString(chars))) {
            return string2;
          }
          var strSymbols = stringToArray(string2), chrSymbols = stringToArray(chars), start = charsStartIndex(strSymbols, chrSymbols), end = charsEndIndex(strSymbols, chrSymbols) + 1;
          return castSlice(strSymbols, start, end).join("");
        }
        function trimEnd2(string2, chars, guard) {
          string2 = toString2(string2);
          if (string2 && (guard || chars === undefined$1)) {
            return string2.slice(0, trimmedEndIndex(string2) + 1);
          }
          if (!string2 || !(chars = baseToString(chars))) {
            return string2;
          }
          var strSymbols = stringToArray(string2), end = charsEndIndex(strSymbols, stringToArray(chars)) + 1;
          return castSlice(strSymbols, 0, end).join("");
        }
        function trimStart2(string2, chars, guard) {
          string2 = toString2(string2);
          if (string2 && (guard || chars === undefined$1)) {
            return string2.replace(reTrimStart, "");
          }
          if (!string2 || !(chars = baseToString(chars))) {
            return string2;
          }
          var strSymbols = stringToArray(string2), start = charsStartIndex(strSymbols, stringToArray(chars));
          return castSlice(strSymbols, start).join("");
        }
        function truncate(string2, options) {
          var length = DEFAULT_TRUNC_LENGTH, omission = DEFAULT_TRUNC_OMISSION;
          if (isObject2(options)) {
            var separator = "separator" in options ? options.separator : separator;
            length = "length" in options ? toInteger(options.length) : length;
            omission = "omission" in options ? baseToString(options.omission) : omission;
          }
          string2 = toString2(string2);
          var strLength = string2.length;
          if (hasUnicode(string2)) {
            var strSymbols = stringToArray(string2);
            strLength = strSymbols.length;
          }
          if (length >= strLength) {
            return string2;
          }
          var end = length - stringSize(omission);
          if (end < 1) {
            return omission;
          }
          var result2 = strSymbols ? castSlice(strSymbols, 0, end).join("") : string2.slice(0, end);
          if (separator === undefined$1) {
            return result2 + omission;
          }
          if (strSymbols) {
            end += result2.length - end;
          }
          if (isRegExp(separator)) {
            if (string2.slice(end).search(separator)) {
              var match, substring = result2;
              if (!separator.global) {
                separator = RegExp2(separator.source, toString2(reFlags.exec(separator)) + "g");
              }
              separator.lastIndex = 0;
              while (match = separator.exec(substring)) {
                var newEnd = match.index;
              }
              result2 = result2.slice(0, newEnd === undefined$1 ? end : newEnd);
            }
          } else if (string2.indexOf(baseToString(separator), end) != end) {
            var index = result2.lastIndexOf(separator);
            if (index > -1) {
              result2 = result2.slice(0, index);
            }
          }
          return result2 + omission;
        }
        function unescape(string2) {
          string2 = toString2(string2);
          return string2 && reHasEscapedHtml.test(string2) ? string2.replace(reEscapedHtml, unescapeHtmlChar) : string2;
        }
        var upperCase = createCompounder(function(result2, word, index) {
          return result2 + (index ? " " : "") + word.toUpperCase();
        });
        var upperFirst = createCaseFirst("toUpperCase");
        function words(string2, pattern, guard) {
          string2 = toString2(string2);
          pattern = guard ? undefined$1 : pattern;
          if (pattern === undefined$1) {
            return hasUnicodeWord(string2) ? unicodeWords(string2) : asciiWords(string2);
          }
          return string2.match(pattern) || [];
        }
        var attempt = baseRest(function(func, args) {
          try {
            return apply(func, undefined$1, args);
          } catch (e) {
            return isError(e) ? e : new Error2(e);
          }
        });
        var bindAll = flatRest(function(object, methodNames) {
          arrayEach(methodNames, function(key) {
            key = toKey(key);
            baseAssignValue(object, key, bind(object[key], object));
          });
          return object;
        });
        function cond(pairs) {
          var length = pairs == null ? 0 : pairs.length, toIteratee = getIteratee();
          pairs = !length ? [] : arrayMap(pairs, function(pair) {
            if (typeof pair[1] != "function") {
              throw new TypeError2(FUNC_ERROR_TEXT);
            }
            return [toIteratee(pair[0]), pair[1]];
          });
          return baseRest(function(args) {
            var index = -1;
            while (++index < length) {
              var pair = pairs[index];
              if (apply(pair[0], this, args)) {
                return apply(pair[1], this, args);
              }
            }
          });
        }
        function conforms(source) {
          return baseConforms(baseClone(source, CLONE_DEEP_FLAG));
        }
        function constant(value2) {
          return function() {
            return value2;
          };
        }
        function defaultTo(value2, defaultValue) {
          return value2 == null || value2 !== value2 ? defaultValue : value2;
        }
        var flow = createFlow();
        var flowRight = createFlow(true);
        function identity(value2) {
          return value2;
        }
        function iteratee(func) {
          return baseIteratee(typeof func == "function" ? func : baseClone(func, CLONE_DEEP_FLAG));
        }
        function matches(source) {
          return baseMatches(baseClone(source, CLONE_DEEP_FLAG));
        }
        function matchesProperty(path, srcValue) {
          return baseMatchesProperty(path, baseClone(srcValue, CLONE_DEEP_FLAG));
        }
        var method = baseRest(function(path, args) {
          return function(object) {
            return baseInvoke(object, path, args);
          };
        });
        var methodOf = baseRest(function(object, args) {
          return function(path) {
            return baseInvoke(object, path, args);
          };
        });
        function mixin(object, source, options) {
          var props = keys(source), methodNames = baseFunctions(source, props);
          if (options == null && !(isObject2(source) && (methodNames.length || !props.length))) {
            options = source;
            source = object;
            object = this;
            methodNames = baseFunctions(source, keys(source));
          }
          var chain2 = !(isObject2(options) && "chain" in options) || !!options.chain, isFunc = isFunction(object);
          arrayEach(methodNames, function(methodName) {
            var func = source[methodName];
            object[methodName] = func;
            if (isFunc) {
              object.prototype[methodName] = function() {
                var chainAll = this.__chain__;
                if (chain2 || chainAll) {
                  var result2 = object(this.__wrapped__), actions = result2.__actions__ = copyArray(this.__actions__);
                  actions.push({ "func": func, "args": arguments, "thisArg": object });
                  result2.__chain__ = chainAll;
                  return result2;
                }
                return func.apply(object, arrayPush([this.value()], arguments));
              };
            }
          });
          return object;
        }
        function noConflict() {
          if (root._ === this) {
            root._ = oldDash;
          }
          return this;
        }
        function noop() {
        }
        function nthArg(n) {
          n = toInteger(n);
          return baseRest(function(args) {
            return baseNth(args, n);
          });
        }
        var over = createOver(arrayMap);
        var overEvery = createOver(arrayEvery);
        var overSome = createOver(arraySome);
        function property(path) {
          return isKey(path) ? baseProperty(toKey(path)) : basePropertyDeep(path);
        }
        function propertyOf(object) {
          return function(path) {
            return object == null ? undefined$1 : baseGet(object, path);
          };
        }
        var range2 = createRange();
        var rangeRight = createRange(true);
        function stubArray() {
          return [];
        }
        function stubFalse() {
          return false;
        }
        function stubObject() {
          return {};
        }
        function stubString() {
          return "";
        }
        function stubTrue() {
          return true;
        }
        function times(n, iteratee2) {
          n = toInteger(n);
          if (n < 1 || n > MAX_SAFE_INTEGER) {
            return [];
          }
          var index = MAX_ARRAY_LENGTH, length = nativeMin(n, MAX_ARRAY_LENGTH);
          iteratee2 = getIteratee(iteratee2);
          n -= MAX_ARRAY_LENGTH;
          var result2 = baseTimes(length, iteratee2);
          while (++index < n) {
            iteratee2(index);
          }
          return result2;
        }
        function toPath(value2) {
          if (isArray(value2)) {
            return arrayMap(value2, toKey);
          }
          return isSymbol(value2) ? [value2] : copyArray(stringToPath(toString2(value2)));
        }
        function uniqueId(prefix) {
          var id = ++idCounter;
          return toString2(prefix) + id;
        }
        var add = createMathOperation(function(augend, addend) {
          return augend + addend;
        }, 0);
        var ceil = createRound("ceil");
        var divide = createMathOperation(function(dividend, divisor) {
          return dividend / divisor;
        }, 1);
        var floor = createRound("floor");
        function max(array) {
          return array && array.length ? baseExtremum(array, identity, baseGt) : undefined$1;
        }
        function maxBy(array, iteratee2) {
          return array && array.length ? baseExtremum(array, getIteratee(iteratee2, 2), baseGt) : undefined$1;
        }
        function mean(array) {
          return baseMean(array, identity);
        }
        function meanBy(array, iteratee2) {
          return baseMean(array, getIteratee(iteratee2, 2));
        }
        function min(array) {
          return array && array.length ? baseExtremum(array, identity, baseLt) : undefined$1;
        }
        function minBy(array, iteratee2) {
          return array && array.length ? baseExtremum(array, getIteratee(iteratee2, 2), baseLt) : undefined$1;
        }
        var multiply = createMathOperation(function(multiplier, multiplicand) {
          return multiplier * multiplicand;
        }, 1);
        var round = createRound("round");
        var subtract = createMathOperation(function(minuend, subtrahend) {
          return minuend - subtrahend;
        }, 0);
        function sum(array) {
          return array && array.length ? baseSum(array, identity) : 0;
        }
        function sumBy(array, iteratee2) {
          return array && array.length ? baseSum(array, getIteratee(iteratee2, 2)) : 0;
        }
        lodash2.after = after;
        lodash2.ary = ary;
        lodash2.assign = assign;
        lodash2.assignIn = assignIn;
        lodash2.assignInWith = assignInWith;
        lodash2.assignWith = assignWith;
        lodash2.at = at;
        lodash2.before = before;
        lodash2.bind = bind;
        lodash2.bindAll = bindAll;
        lodash2.bindKey = bindKey;
        lodash2.castArray = castArray;
        lodash2.chain = chain;
        lodash2.chunk = chunk;
        lodash2.compact = compact;
        lodash2.concat = concat;
        lodash2.cond = cond;
        lodash2.conforms = conforms;
        lodash2.constant = constant;
        lodash2.countBy = countBy;
        lodash2.create = create;
        lodash2.curry = curry;
        lodash2.curryRight = curryRight;
        lodash2.debounce = debounce;
        lodash2.defaults = defaults;
        lodash2.defaultsDeep = defaultsDeep;
        lodash2.defer = defer;
        lodash2.delay = delay;
        lodash2.difference = difference;
        lodash2.differenceBy = differenceBy;
        lodash2.differenceWith = differenceWith;
        lodash2.drop = drop;
        lodash2.dropRight = dropRight;
        lodash2.dropRightWhile = dropRightWhile;
        lodash2.dropWhile = dropWhile;
        lodash2.fill = fill;
        lodash2.filter = filter;
        lodash2.flatMap = flatMap;
        lodash2.flatMapDeep = flatMapDeep;
        lodash2.flatMapDepth = flatMapDepth;
        lodash2.flatten = flatten;
        lodash2.flattenDeep = flattenDeep;
        lodash2.flattenDepth = flattenDepth;
        lodash2.flip = flip;
        lodash2.flow = flow;
        lodash2.flowRight = flowRight;
        lodash2.fromPairs = fromPairs;
        lodash2.functions = functions;
        lodash2.functionsIn = functionsIn;
        lodash2.groupBy = groupBy;
        lodash2.initial = initial;
        lodash2.intersection = intersection;
        lodash2.intersectionBy = intersectionBy;
        lodash2.intersectionWith = intersectionWith;
        lodash2.invert = invert;
        lodash2.invertBy = invertBy;
        lodash2.invokeMap = invokeMap;
        lodash2.iteratee = iteratee;
        lodash2.keyBy = keyBy;
        lodash2.keys = keys;
        lodash2.keysIn = keysIn;
        lodash2.map = map2;
        lodash2.mapKeys = mapKeys;
        lodash2.mapValues = mapValues;
        lodash2.matches = matches;
        lodash2.matchesProperty = matchesProperty;
        lodash2.memoize = memoize2;
        lodash2.merge = merge;
        lodash2.mergeWith = mergeWith;
        lodash2.method = method;
        lodash2.methodOf = methodOf;
        lodash2.mixin = mixin;
        lodash2.negate = negate;
        lodash2.nthArg = nthArg;
        lodash2.omit = omit;
        lodash2.omitBy = omitBy;
        lodash2.once = once;
        lodash2.orderBy = orderBy;
        lodash2.over = over;
        lodash2.overArgs = overArgs;
        lodash2.overEvery = overEvery;
        lodash2.overSome = overSome;
        lodash2.partial = partial;
        lodash2.partialRight = partialRight;
        lodash2.partition = partition;
        lodash2.pick = pick;
        lodash2.pickBy = pickBy;
        lodash2.property = property;
        lodash2.propertyOf = propertyOf;
        lodash2.pull = pull;
        lodash2.pullAll = pullAll;
        lodash2.pullAllBy = pullAllBy;
        lodash2.pullAllWith = pullAllWith;
        lodash2.pullAt = pullAt;
        lodash2.range = range2;
        lodash2.rangeRight = rangeRight;
        lodash2.rearg = rearg;
        lodash2.reject = reject;
        lodash2.remove = remove;
        lodash2.rest = rest;
        lodash2.reverse = reverse;
        lodash2.sampleSize = sampleSize;
        lodash2.set = set;
        lodash2.setWith = setWith;
        lodash2.shuffle = shuffle;
        lodash2.slice = slice;
        lodash2.sortBy = sortBy;
        lodash2.sortedUniq = sortedUniq;
        lodash2.sortedUniqBy = sortedUniqBy;
        lodash2.split = split;
        lodash2.spread = spread;
        lodash2.tail = tail;
        lodash2.take = take;
        lodash2.takeRight = takeRight;
        lodash2.takeRightWhile = takeRightWhile;
        lodash2.takeWhile = takeWhile;
        lodash2.tap = tap;
        lodash2.throttle = throttle;
        lodash2.thru = thru;
        lodash2.toArray = toArray;
        lodash2.toPairs = toPairs;
        lodash2.toPairsIn = toPairsIn;
        lodash2.toPath = toPath;
        lodash2.toPlainObject = toPlainObject;
        lodash2.transform = transform;
        lodash2.unary = unary;
        lodash2.union = union;
        lodash2.unionBy = unionBy;
        lodash2.unionWith = unionWith;
        lodash2.uniq = uniq;
        lodash2.uniqBy = uniqBy;
        lodash2.uniqWith = uniqWith;
        lodash2.unset = unset;
        lodash2.unzip = unzip;
        lodash2.unzipWith = unzipWith;
        lodash2.update = update;
        lodash2.updateWith = updateWith;
        lodash2.values = values;
        lodash2.valuesIn = valuesIn;
        lodash2.without = without;
        lodash2.words = words;
        lodash2.wrap = wrap;
        lodash2.xor = xor;
        lodash2.xorBy = xorBy;
        lodash2.xorWith = xorWith;
        lodash2.zip = zip;
        lodash2.zipObject = zipObject;
        lodash2.zipObjectDeep = zipObjectDeep;
        lodash2.zipWith = zipWith;
        lodash2.entries = toPairs;
        lodash2.entriesIn = toPairsIn;
        lodash2.extend = assignIn;
        lodash2.extendWith = assignInWith;
        mixin(lodash2, lodash2);
        lodash2.add = add;
        lodash2.attempt = attempt;
        lodash2.camelCase = camelCase;
        lodash2.capitalize = capitalize;
        lodash2.ceil = ceil;
        lodash2.clamp = clamp;
        lodash2.clone = clone;
        lodash2.cloneDeep = cloneDeep;
        lodash2.cloneDeepWith = cloneDeepWith;
        lodash2.cloneWith = cloneWith;
        lodash2.conformsTo = conformsTo;
        lodash2.deburr = deburr;
        lodash2.defaultTo = defaultTo;
        lodash2.divide = divide;
        lodash2.endsWith = endsWith;
        lodash2.eq = eq;
        lodash2.escape = escape;
        lodash2.escapeRegExp = escapeRegExp;
        lodash2.every = every;
        lodash2.find = find;
        lodash2.findIndex = findIndex;
        lodash2.findKey = findKey;
        lodash2.findLast = findLast;
        lodash2.findLastIndex = findLastIndex;
        lodash2.findLastKey = findLastKey;
        lodash2.floor = floor;
        lodash2.forEach = forEach;
        lodash2.forEachRight = forEachRight;
        lodash2.forIn = forIn;
        lodash2.forInRight = forInRight;
        lodash2.forOwn = forOwn;
        lodash2.forOwnRight = forOwnRight;
        lodash2.get = get;
        lodash2.gt = gt;
        lodash2.gte = gte;
        lodash2.has = has;
        lodash2.hasIn = hasIn;
        lodash2.head = head;
        lodash2.identity = identity;
        lodash2.includes = includes;
        lodash2.indexOf = indexOf;
        lodash2.inRange = inRange;
        lodash2.invoke = invoke;
        lodash2.isArguments = isArguments;
        lodash2.isArray = isArray;
        lodash2.isArrayBuffer = isArrayBuffer;
        lodash2.isArrayLike = isArrayLike;
        lodash2.isArrayLikeObject = isArrayLikeObject;
        lodash2.isBoolean = isBoolean;
        lodash2.isBuffer = isBuffer;
        lodash2.isDate = isDate;
        lodash2.isElement = isElement;
        lodash2.isEmpty = isEmpty;
        lodash2.isEqual = isEqual;
        lodash2.isEqualWith = isEqualWith;
        lodash2.isError = isError;
        lodash2.isFinite = isFinite2;
        lodash2.isFunction = isFunction;
        lodash2.isInteger = isInteger2;
        lodash2.isLength = isLength;
        lodash2.isMap = isMap;
        lodash2.isMatch = isMatch;
        lodash2.isMatchWith = isMatchWith;
        lodash2.isNaN = isNaN;
        lodash2.isNative = isNative;
        lodash2.isNil = isNil;
        lodash2.isNull = isNull;
        lodash2.isNumber = isNumber2;
        lodash2.isObject = isObject2;
        lodash2.isObjectLike = isObjectLike;
        lodash2.isPlainObject = isPlainObject;
        lodash2.isRegExp = isRegExp;
        lodash2.isSafeInteger = isSafeInteger2;
        lodash2.isSet = isSet;
        lodash2.isString = isString;
        lodash2.isSymbol = isSymbol;
        lodash2.isTypedArray = isTypedArray;
        lodash2.isUndefined = isUndefined;
        lodash2.isWeakMap = isWeakMap;
        lodash2.isWeakSet = isWeakSet;
        lodash2.join = join;
        lodash2.kebabCase = kebabCase;
        lodash2.last = last;
        lodash2.lastIndexOf = lastIndexOf;
        lodash2.lowerCase = lowerCase;
        lodash2.lowerFirst = lowerFirst;
        lodash2.lt = lt;
        lodash2.lte = lte;
        lodash2.max = max;
        lodash2.maxBy = maxBy;
        lodash2.mean = mean;
        lodash2.meanBy = meanBy;
        lodash2.min = min;
        lodash2.minBy = minBy;
        lodash2.stubArray = stubArray;
        lodash2.stubFalse = stubFalse;
        lodash2.stubObject = stubObject;
        lodash2.stubString = stubString;
        lodash2.stubTrue = stubTrue;
        lodash2.multiply = multiply;
        lodash2.nth = nth;
        lodash2.noConflict = noConflict;
        lodash2.noop = noop;
        lodash2.now = now2;
        lodash2.pad = pad;
        lodash2.padEnd = padEnd;
        lodash2.padStart = padStart;
        lodash2.parseInt = parseInt2;
        lodash2.random = random;
        lodash2.reduce = reduce;
        lodash2.reduceRight = reduceRight;
        lodash2.repeat = repeat;
        lodash2.replace = replace;
        lodash2.result = result;
        lodash2.round = round;
        lodash2.runInContext = runInContext2;
        lodash2.sample = sample;
        lodash2.size = size;
        lodash2.snakeCase = snakeCase;
        lodash2.some = some;
        lodash2.sortedIndex = sortedIndex;
        lodash2.sortedIndexBy = sortedIndexBy;
        lodash2.sortedIndexOf = sortedIndexOf;
        lodash2.sortedLastIndex = sortedLastIndex;
        lodash2.sortedLastIndexBy = sortedLastIndexBy;
        lodash2.sortedLastIndexOf = sortedLastIndexOf;
        lodash2.startCase = startCase;
        lodash2.startsWith = startsWith2;
        lodash2.subtract = subtract;
        lodash2.sum = sum;
        lodash2.sumBy = sumBy;
        lodash2.template = template;
        lodash2.times = times;
        lodash2.toFinite = toFinite;
        lodash2.toInteger = toInteger;
        lodash2.toLength = toLength;
        lodash2.toLower = toLower;
        lodash2.toNumber = toNumber;
        lodash2.toSafeInteger = toSafeInteger;
        lodash2.toString = toString2;
        lodash2.toUpper = toUpper;
        lodash2.trim = trim;
        lodash2.trimEnd = trimEnd2;
        lodash2.trimStart = trimStart2;
        lodash2.truncate = truncate;
        lodash2.unescape = unescape;
        lodash2.uniqueId = uniqueId;
        lodash2.upperCase = upperCase;
        lodash2.upperFirst = upperFirst;
        lodash2.each = forEach;
        lodash2.eachRight = forEachRight;
        lodash2.first = head;
        mixin(lodash2, function() {
          var source = {};
          baseForOwn(lodash2, function(func, methodName) {
            if (!hasOwnProperty.call(lodash2.prototype, methodName)) {
              source[methodName] = func;
            }
          });
          return source;
        }(), { "chain": false });
        lodash2.VERSION = VERSION;
        arrayEach(["bind", "bindKey", "curry", "curryRight", "partial", "partialRight"], function(methodName) {
          lodash2[methodName].placeholder = lodash2;
        });
        arrayEach(["drop", "take"], function(methodName, index) {
          LazyWrapper.prototype[methodName] = function(n) {
            n = n === undefined$1 ? 1 : nativeMax(toInteger(n), 0);
            var result2 = this.__filtered__ && !index ? new LazyWrapper(this) : this.clone();
            if (result2.__filtered__) {
              result2.__takeCount__ = nativeMin(n, result2.__takeCount__);
            } else {
              result2.__views__.push({
                "size": nativeMin(n, MAX_ARRAY_LENGTH),
                "type": methodName + (result2.__dir__ < 0 ? "Right" : "")
              });
            }
            return result2;
          };
          LazyWrapper.prototype[methodName + "Right"] = function(n) {
            return this.reverse()[methodName](n).reverse();
          };
        });
        arrayEach(["filter", "map", "takeWhile"], function(methodName, index) {
          var type = index + 1, isFilter = type == LAZY_FILTER_FLAG || type == LAZY_WHILE_FLAG;
          LazyWrapper.prototype[methodName] = function(iteratee2) {
            var result2 = this.clone();
            result2.__iteratees__.push({
              "iteratee": getIteratee(iteratee2, 3),
              "type": type
            });
            result2.__filtered__ = result2.__filtered__ || isFilter;
            return result2;
          };
        });
        arrayEach(["head", "last"], function(methodName, index) {
          var takeName = "take" + (index ? "Right" : "");
          LazyWrapper.prototype[methodName] = function() {
            return this[takeName](1).value()[0];
          };
        });
        arrayEach(["initial", "tail"], function(methodName, index) {
          var dropName = "drop" + (index ? "" : "Right");
          LazyWrapper.prototype[methodName] = function() {
            return this.__filtered__ ? new LazyWrapper(this) : this[dropName](1);
          };
        });
        LazyWrapper.prototype.compact = function() {
          return this.filter(identity);
        };
        LazyWrapper.prototype.find = function(predicate) {
          return this.filter(predicate).head();
        };
        LazyWrapper.prototype.findLast = function(predicate) {
          return this.reverse().find(predicate);
        };
        LazyWrapper.prototype.invokeMap = baseRest(function(path, args) {
          if (typeof path == "function") {
            return new LazyWrapper(this);
          }
          return this.map(function(value2) {
            return baseInvoke(value2, path, args);
          });
        });
        LazyWrapper.prototype.reject = function(predicate) {
          return this.filter(negate(getIteratee(predicate)));
        };
        LazyWrapper.prototype.slice = function(start, end) {
          start = toInteger(start);
          var result2 = this;
          if (result2.__filtered__ && (start > 0 || end < 0)) {
            return new LazyWrapper(result2);
          }
          if (start < 0) {
            result2 = result2.takeRight(-start);
          } else if (start) {
            result2 = result2.drop(start);
          }
          if (end !== undefined$1) {
            end = toInteger(end);
            result2 = end < 0 ? result2.dropRight(-end) : result2.take(end - start);
          }
          return result2;
        };
        LazyWrapper.prototype.takeRightWhile = function(predicate) {
          return this.reverse().takeWhile(predicate).reverse();
        };
        LazyWrapper.prototype.toArray = function() {
          return this.take(MAX_ARRAY_LENGTH);
        };
        baseForOwn(LazyWrapper.prototype, function(func, methodName) {
          var checkIteratee = /^(?:filter|find|map|reject)|While$/.test(methodName), isTaker = /^(?:head|last)$/.test(methodName), lodashFunc = lodash2[isTaker ? "take" + (methodName == "last" ? "Right" : "") : methodName], retUnwrapped = isTaker || /^find/.test(methodName);
          if (!lodashFunc) {
            return;
          }
          lodash2.prototype[methodName] = function() {
            var value2 = this.__wrapped__, args = isTaker ? [1] : arguments, isLazy = value2 instanceof LazyWrapper, iteratee2 = args[0], useLazy = isLazy || isArray(value2);
            var interceptor = function(value3) {
              var result3 = lodashFunc.apply(lodash2, arrayPush([value3], args));
              return isTaker && chainAll ? result3[0] : result3;
            };
            if (useLazy && checkIteratee && typeof iteratee2 == "function" && iteratee2.length != 1) {
              isLazy = useLazy = false;
            }
            var chainAll = this.__chain__, isHybrid = !!this.__actions__.length, isUnwrapped = retUnwrapped && !chainAll, onlyLazy = isLazy && !isHybrid;
            if (!retUnwrapped && useLazy) {
              value2 = onlyLazy ? value2 : new LazyWrapper(this);
              var result2 = func.apply(value2, args);
              result2.__actions__.push({ "func": thru, "args": [interceptor], "thisArg": undefined$1 });
              return new LodashWrapper(result2, chainAll);
            }
            if (isUnwrapped && onlyLazy) {
              return func.apply(this, args);
            }
            result2 = this.thru(interceptor);
            return isUnwrapped ? isTaker ? result2.value()[0] : result2.value() : result2;
          };
        });
        arrayEach(["pop", "push", "shift", "sort", "splice", "unshift"], function(methodName) {
          var func = arrayProto[methodName], chainName = /^(?:push|sort|unshift)$/.test(methodName) ? "tap" : "thru", retUnwrapped = /^(?:pop|shift)$/.test(methodName);
          lodash2.prototype[methodName] = function() {
            var args = arguments;
            if (retUnwrapped && !this.__chain__) {
              var value2 = this.value();
              return func.apply(isArray(value2) ? value2 : [], args);
            }
            return this[chainName](function(value3) {
              return func.apply(isArray(value3) ? value3 : [], args);
            });
          };
        });
        baseForOwn(LazyWrapper.prototype, function(func, methodName) {
          var lodashFunc = lodash2[methodName];
          if (lodashFunc) {
            var key = lodashFunc.name + "";
            if (!hasOwnProperty.call(realNames, key)) {
              realNames[key] = [];
            }
            realNames[key].push({ "name": methodName, "func": lodashFunc });
          }
        });
        realNames[createHybrid(undefined$1, WRAP_BIND_KEY_FLAG).name] = [{
          "name": "wrapper",
          "func": undefined$1
        }];
        LazyWrapper.prototype.clone = lazyClone;
        LazyWrapper.prototype.reverse = lazyReverse;
        LazyWrapper.prototype.value = lazyValue;
        lodash2.prototype.at = wrapperAt;
        lodash2.prototype.chain = wrapperChain;
        lodash2.prototype.commit = wrapperCommit;
        lodash2.prototype.next = wrapperNext;
        lodash2.prototype.plant = wrapperPlant;
        lodash2.prototype.reverse = wrapperReverse;
        lodash2.prototype.toJSON = lodash2.prototype.valueOf = lodash2.prototype.value = wrapperValue;
        lodash2.prototype.first = lodash2.prototype.head;
        if (symIterator) {
          lodash2.prototype[symIterator] = wrapperToIterator;
        }
        return lodash2;
      };
      var _ = runInContext();
      if (freeModule) {
        (freeModule.exports = _)._ = _;
        freeExports._ = _;
      } else {
        root._ = _;
      }
    }).call(commonjsGlobal);
  })(lodash, lodash.exports);
  var lodashExports = lodash.exports;
  function createTypeParser(parser) {
    return (value2) => {
      if (isNullish(value2)) return;
      return parser(value2);
    };
  }
  function quantityLike(value2) {
    const { value: valueQuantity, comparator, unit, system, code: code2 } = value2;
    return { value: valueQuantity, comparator, unit, system, code: code2 };
  }
  const quantity$1 = createTypeParser(quantityLike);
  const dateTime$3 = createTypeParser((value2) => value2);
  const reference$1 = createTypeParser((value2) => {
    const { reference: reference2, display } = value2;
    return {
      reference: reference2,
      display
    };
  });
  const annotation$1 = createTypeParser((value2) => {
    const { time, text, authorReference } = value2;
    return {
      time: dateTime$3(time),
      text,
      author: reference$1(authorReference)
    };
  });
  const boolean$1 = createTypeParser((value2) => value2);
  const code$1 = createTypeParser((value2) => value2);
  const nictizIdValueXMap = {
    "BodySite-Qualifier": "codeableConcept",
    "BodySite-Morphology": "codeableConcept",
    "deviceUseStatement-reasonReferenceSTU3": "reference",
    "zib-MedicalDevice-Organization": "reference",
    "zib-MedicalDevice-Practitioner": "reference",
    "zib-MedicationUse-AsAgreedIndicator": "boolean",
    "zib-MedicationUse-Prescriber": "reference",
    "zib-MedicationUse-Author": "reference",
    "zib-MedicationUse-ReasonForChangeOrDiscontinuationOfUse": "codeableConcept",
    "zib-Medication-MedicationTreatment": "identifier",
    "zib-Medication-RepeatPeriodCyclicalSchedule": "duration",
    "zib-MedicationUse-Duration": "duration",
    "zib-Product-Description": "string",
    "zib-NutritionAdvice-Explanation": "string",
    "zib-Medication-PeriodOfUse": "period",
    "zib-Medication-AdditionalInformation": "codeableConcept",
    "zib-Medication-StopType": "codeableConcept",
    "zib-AdministrationAgreement-AuthoredOn": "dateTime",
    "zib-AdministrationAgreement-AgreementReason": "string",
    "zib-AdvanceDirective-Disorder": "reference",
    "zib-VaccinationRecommendation-OrderStatus": "codeableConcept",
    "ext-Vaccination.PharmaceuticalProduct": "reference",
    Comment: "string"
  };
  function extensionNictiz(resource, zibId) {
    return extension(
      resource,
      `http://nictiz.nl/fhir/StructureDefinition/${zibId}`,
      nictizIdValueXMap[zibId]
    );
  }
  function passThrough(value2) {
    return value2;
  }
  function findComponentByCode(components, code2) {
    return components?.find((component) => component.code.coding?.find((x) => x.code === code2));
  }
  function oneOfValueX$1(value2, valueArray, valuePrefix = "value") {
    if (isNullish(value2)) return {};
    for (const valueKey of valueArray) {
      const parsedValue = valueX(
        value2,
        valueKey,
        valuePrefix
      );
      if (isNonNullish(parsedValue)) {
        return {
          [`${valuePrefix}${capitalizeFirstLetter(valueKey)}`]: parsedValue
        };
      }
    }
    return {};
  }
  function filterCodeableConceptByCoding(items, iteratee) {
    return items?.filter((item) => item.coding?.some(iteratee));
  }
  function filterPrimitive(element, key, metaFilter) {
    if (!element) return void 0;
    const value2 = element[key];
    const valueMeta = element[`_${key}`];
    if (Array.isArray(value2)) {
      if (!Array.isArray(valueMeta)) {
        return [];
      }
      return value2.filter((_x, i) => {
        const meta = valueMeta[i];
        return meta && metaFilter(meta);
      });
    }
    if (valueMeta && metaFilter(valueMeta)) {
      return value2;
    }
    return void 0;
  }
  function filterPrimitiveByExtension(element, key, extension2) {
    return filterPrimitive(element, key, (meta) => {
      if (!meta.extension) {
        return false;
      }
      const extensionEntries = Object.entries(extension2);
      return meta.extension.some((ext) => {
        for (const [key2, value2] of extensionEntries) {
          if (ext[key2] !== value2) return false;
        }
        return true;
      });
    });
  }
  const coding$1 = createTypeParser((value2) => {
    const { code: code2, display, system } = value2;
    return {
      code: code2,
      display,
      system
    };
  });
  const codeableConcept$1 = createTypeParser((value2) => {
    if (!value2.coding?.length) {
      return {
        text: value2.text,
        coding: []
      };
    }
    return {
      text: value2.text,
      coding: map(value2.coding, coding$1, true)
    };
  });
  const date$4 = createTypeParser((value2) => value2);
  const duration$1 = createTypeParser(quantityLike);
  const identifier$1 = createTypeParser((value2) => {
    const { use, system, value: identifierValue, type } = value2;
    return {
      use,
      system,
      value: identifierValue,
      type: codeableConcept$1(type)
    };
  });
  const period$1 = createTypeParser((value2) => {
    const { start, end } = value2;
    return {
      start: dateTime$3(start),
      end: dateTime$3(end)
    };
  });
  const range$1 = createTypeParser((value2) => {
    return {
      low: quantity$1(value2.low),
      high: quantity$1(value2.high)
    };
  });
  const ratio$1 = createTypeParser((value2) => {
    const { numerator, denominator } = value2;
    return {
      numerator: quantity$1(numerator),
      denominator: quantity$1(denominator)
    };
  });
  const string$1 = createTypeParser((value2) => value2);
  const decimal$1 = createTypeParser(passThrough);
  const unsignedInt$1 = createTypeParser(passThrough);
  const integer$1 = createTypeParser(passThrough);
  const integer64$1 = createTypeParser(passThrough);
  const positiveInt$1 = createTypeParser(passThrough);
  const parse$1 = /* @__PURE__ */ Object.freeze(/* @__PURE__ */ Object.defineProperty({
    __proto__: null,
    annotation: annotation$1,
    boolean: boolean$1,
    code: code$1,
    codeableConcept: codeableConcept$1,
    coding: coding$1,
    date: date$4,
    dateTime: dateTime$3,
    decimal: decimal$1,
    duration: duration$1,
    identifier: identifier$1,
    integer: integer$1,
    integer64: integer64$1,
    period: period$1,
    positiveInt: positiveInt$1,
    quantity: quantity$1,
    range: range$1,
    ratio: ratio$1,
    reference: reference$1,
    string: string$1,
    unsignedInt: unsignedInt$1
  }, Symbol.toStringTag, { value: "Module" }));
  function valueX(value2, valueXType, valuePrefix = "value") {
    if (isNullish(value2)) return;
    const parser = parse$1[valueXType];
    const valueX2 = value2[`${valuePrefix}${lodashExports.upperFirst(valueXType)}`];
    return parser(valueX2);
  }
  function getExtension(resource, url) {
    return resource?.extension?.find((x) => x.url === url) ?? resource?.modifierExtension?.find((x) => x.url === url);
  }
  function extension(resource, url, valueType) {
    const extension2 = getExtension(resource, url);
    return valueX(extension2, valueType);
  }
  function resourceMeta(resource, profile2, fhirVersion) {
    const { resourceType: fhirResourceType, id, meta } = resource;
    if (!meta?.profile?.includes(profile2)) {
      throw new Error(
        `Resource does not have the expected profile: "${profile2}". Got: ${meta?.profile}`
      );
    }
    const resourceId = string$1(id);
    const resourceType = string$1(fhirResourceType);
    return {
      id: resourceId,
      referenceId: `${resourceType}/${resourceId}`,
      resourceType,
      profile: profile2,
      fhirVersion: `${fhirVersion}`
    };
  }
  const uiSchemaGroup$z = (resource, context) => {
    const i18n = "zib_laboratory_test_result_observation.reference_range";
    const ui = context.ui;
    return {
      label: `${i18n}`,
      children: [
        ui.quantity(`${i18n}.low`, resource.low),
        ui.quantity(`${i18n}.high`, resource.high)
      ]
    };
  };
  function parseReferenceRange(value2) {
    return {
      low: quantity$1(value2?.low),
      high: quantity$1(value2?.high)
    };
  }
  const referenceRange = {
    parse: parseReferenceRange,
    uiSchemaGroup: uiSchemaGroup$z
  };
  const uiSchemaGroup$y = (resource, context) => {
    const ui = context.ui;
    return {
      label: "zib_laboratory_test_result_observation.related",
      children: [ui.reference(`zib_laboratory_test_result_observation.related`, resource.target)]
    };
  };
  function parseRelated(value2) {
    return {
      target: reference$1(value2?.target)
    };
  }
  const related = {
    parse: parseRelated,
    uiSchemaGroup: uiSchemaGroup$y
  };
  const uiSchema$J = (resource, context) => {
    const ui = context.ui;
    const i18n = "zib_laboratory_test_result_observation";
    const related2 = map(resource.related, (x) => uiSchemaGroup$y(x, context), true);
    const referenceRange2 = map(
      resource.referenceRange,
      (x) => uiSchemaGroup$z(x, context),
      true
    );
    const title = resource.category?.[0]?.coding?.[0]?.display ?? `${i18n}`;
    const effective = typeof resource.effective === "string" ? [ui.dateTime(`${i18n}.effective`, resource.effective)] : ui.period(`${i18n}.effective`, resource.effective);
    return {
      label: title,
      children: [
        {
          label: `${i18n}`,
          children: [
            ui.identifier(`${i18n}.identifier`, resource.identifier),
            ui.reference(`${i18n}.specimen`, resource.specimen),
            ui.codeableConcept(
              "zib_laboratory_test_result_diagnostic_report.code",
              resource.code
            ),
            ui.string(
              "zib_laboratory_test_result_diagnostic_report.status",
              resource.status
            ),
            ui.string(`${i18n}.comment`, resource.comment),
            ui.codeableConcept(`${i18n}.result_type`, resource.category),
            ...ui.helpers.getChildren(related2),
            ui.reference(`${i18n}.based_on`, resource.basedOn)
          ]
        },
        {
          label: `${i18n}.test`,
          children: [
            ui.codeableConcept(`${i18n}.code`, resource.code),
            ui.codeableConcept(`${i18n}.method`, resource.method),
            ...effective,
            ui.quantity(`${i18n}.value`, resource.result),
            ui.string(`${i18n}.status`, resource.status),
            ...ui.helpers.getChildren(referenceRange2),
            ui.codeableConcept(
              `${i18n}.interpretation.interpretatie_vlaggen_codelijst`,
              resource.interpretation
            ),
            ui.string(`${i18n}.comment`, resource.comment)
          ]
        }
      ]
    };
  };
  const profile$J = "http://nictiz.nl/fhir/StructureDefinition/zib-LaboratoryTestResult-Observation";
  function parseZibLaboratoryTestResultObservation(resource) {
    return {
      ...resourceMeta(resource, profile$J, FhirVersion.R3),
      identifier: map(resource.identifier, identifier$1),
      subject: reference$1(resource.subject),
      code: codeableConcept$1(resource?.code),
      // NL-CM:13.1.8
      method: codeableConcept$1(resource?.method),
      // NL-CM:13.1.9
      effective: dateTime$3(resource?.effectiveDateTime) ?? period$1(resource?.effectivePeriod),
      // NL-CM:13.1.13
      result: quantity$1(resource?.valueQuantity),
      // NL-CM:13.1.10
      status: string$1(resource?.status),
      // NL-CM:13.1.31
      referenceRange: map(resource?.referenceRange, referenceRange.parse),
      // NL-CM:13.1.11 & NL-CM:13.1.12
      interpretation: codeableConcept$1(resource?.interpretation),
      // NL-CM:13.1.14
      specimen: reference$1(resource.specimen),
      // NL-CM:13.1.2
      comment: string$1(resource.comment),
      // NL-CM:13.1.5
      category: map(resource.category, codeableConcept$1),
      // NL-CM:13.1.7
      related: map(resource.related, related.parse),
      // NL-CM:13.1.33 or NL-CM:13.1.3
      basedOn: map(resource.basedOn, reference$1)
      // NL-CM:13.1.34
    };
  }
  const zibLaboratoryTestResultObservation = {
    profile: profile$J,
    parse: parseZibLaboratoryTestResultObservation,
    uiSchema: uiSchema$J
  };
  const uiSchema$I = (resource, context) => {
    return zibLaboratoryTestResultObservation.uiSchema(resource, context);
  };
  const profile$I = "http://nictiz.nl/fhir/StructureDefinition/gp-LaboratoryResult";
  function parseGpLaboratoryResult(resource) {
    return {
      ...resourceMeta(resource, profile$I, FhirVersion.R3),
      identifier: map(resource.identifier, identifier$1),
      subject: reference$1(resource.subject),
      code: codeableConcept$1(resource?.code),
      method: codeableConcept$1(resource?.method),
      effective: dateTime$3(resource?.effectiveDateTime) ?? period$1(resource?.effectivePeriod),
      result: quantity$1(resource?.valueQuantity),
      status: string$1(resource?.status),
      referenceRange: map(resource?.referenceRange, referenceRange.parse),
      interpretation: codeableConcept$1(resource?.interpretation),
      specimen: reference$1(resource.specimen),
      comment: string$1(resource.comment),
      category: map(resource.category, codeableConcept$1),
      related: map(resource.related, related.parse),
      basedOn: map(resource.basedOn, reference$1)
    };
  }
  const gpLaboratoryResult = {
    profile: profile$I,
    parse: parseGpLaboratoryResult,
    uiSchema: uiSchema$I
  };
  const uiSchema$H = (resource, context) => {
    const ui = context.ui;
    const profile2 = "gp_diagnostic_result";
    return {
      label: resource.context?.display,
      children: [
        {
          label: `${profile2}.group_details`,
          children: [
            ui.identifier(`${profile2}.identifier`, resource.identifier),
            ui.reference(`${profile2}.context`, resource.context),
            ui.reference(`${profile2}.subject`, resource.subject),
            ui.dateTime(`${profile2}.effective`, resource.effective),
            ui.reference(`${profile2}.performer`, resource.performer),
            ui.string(`${profile2}.status`, resource.status),
            ui.codeableConcept(`${profile2}.code`, resource.code),
            ui.string(`${profile2}.comment`, resource.comment),
            ui.codeableConcept(`${profile2}.method`, resource.method),
            ...ui.oneOfValueX(`${profile2}.value`, resource, "value")
          ]
        }
      ]
    };
  };
  const profile$H = "http://nictiz.nl/fhir/StructureDefinition/gp-DiagnosticResult";
  function parseGpDiagnosticResult(resource) {
    return {
      ...resourceMeta(resource, profile$H, FhirVersion.R3),
      identifier: map(resource.identifier, identifier$1),
      context: reference$1(resource.context),
      subject: reference$1(resource.subject),
      effective: dateTime$3(resource.effectiveDateTime),
      performer: map(resource.performer, reference$1),
      status: string$1(resource.status),
      code: codeableConcept$1(resource.code),
      ...oneOfValueX$1(resource, [
        "quantity",
        "codeableConcept",
        "string",
        "boolean",
        "range",
        "dateTime",
        "period"
      ]),
      comment: string$1(resource.comment),
      method: codeableConcept$1(resource.method)
    };
  }
  const gpDiagnosticResult = {
    profile: profile$H,
    parse: parseGpDiagnosticResult,
    uiSchema: uiSchema$H
  };
  const uiSchemaGroup$x = (resource, context) => {
    const ui = context.ui;
    return {
      label: "Encounter.participant",
      children: [ui.reference(`Encounter.participant.individual`, resource.individual)]
    };
  };
  function parseEncounterParticipant(value2) {
    return {
      individual: reference$1(value2?.individual)
    };
  }
  const encounterParticipant = {
    parse: parseEncounterParticipant,
    uiSchemaGroup: uiSchemaGroup$x
  };
  const uiSchema$G = (resource, context) => {
    const ui = context.ui;
    const profile2 = "Encounter";
    const participants = map(
      resource.participant,
      (x) => uiSchemaGroup$x(x, context),
      true
    ).flat();
    return {
      label: resource.serviceProvider?.display,
      children: [
        {
          label: `${profile2}`,
          children: [
            ui.coding(`${profile2}.class`, resource.class),
            ...ui.helpers.getChildren(participants),
            ui.reference(`${profile2}.serviceProvider`, resource.serviceProvider),
            ...ui.period(`${profile2}.period`, resource.period),
            ui.codeableConcept(`${profile2}.reason`, resource.reason)
          ]
        }
      ]
    };
  };
  const profile$G = "http://nictiz.nl/fhir/StructureDefinition/gp-Encounter";
  function parseGpEncounter(resource) {
    return {
      ...resourceMeta(resource, profile$G, FhirVersion.R3),
      class: coding$1(resource.class),
      participant: map(resource.participant, encounterParticipant.parse),
      serviceProvider: reference$1(resource.serviceProvider),
      period: period$1(resource.period),
      reason: map(resource.reason, codeableConcept$1)
    };
  }
  const gpEncounter = {
    profile: profile$G,
    parse: parseGpEncounter,
    uiSchema: uiSchema$G
  };
  const uiSchema$F = (resource, context) => {
    const ui = context.ui;
    const profile2 = "gp_journal_entry";
    return {
      label: resource.context?.display,
      children: [
        {
          label: `${profile2}.group_details`,
          children: [
            ui.identifier(`${profile2}.identifier`, resource.identifier),
            ui.string(`${profile2}.status`, resource.status),
            ui.codeableConcept(`${profile2}.code`, resource.code),
            ui.reference(`${profile2}.context`, resource.context),
            ...ui.oneOfValueX(`${profile2}.effective`, resource, "effective"),
            ui.reference(`${profile2}.performer`, resource.performer),
            ui.string(`${profile2}.valueString`, resource.valueString),
            ui.codeableConcept(`${profile2}.ICPC_S`, resource.ICPC_S.valueCodeableConcept),
            ui.codeableConcept(`${profile2}.ICPC_E`, resource.ICPC_E.valueCodeableConcept)
          ]
        }
      ]
    };
  };
  const profile$F = "http://nictiz.nl/fhir/StructureDefinition/gp-JournalEntry";
  function parseGpJournalEntry(resource) {
    const ICPC_S = findComponentByCode(resource.component, "ADMDX");
    const ICPC_E = findComponentByCode(resource.component, "DISDX");
    return {
      ...resourceMeta(resource, profile$F, FhirVersion.R3),
      identifier: map(resource.identifier, identifier$1),
      status: string$1(resource.status),
      code: codeableConcept$1(resource.code),
      context: reference$1(resource.context),
      ...oneOfValueX$1(resource, ["dateTime", "period"], "effective"),
      performer: map(resource.performer, reference$1),
      valueString: string$1(resource.valueString),
      ICPC_S: {
        valueCodeableConcept: codeableConcept$1(ICPC_S?.valueCodeableConcept)
      },
      ICPC_E: {
        valueCodeableConcept: codeableConcept$1(ICPC_E?.valueCodeableConcept)
      }
    };
  }
  const gpJournalEntry = {
    profile: profile$F,
    parse: parseGpJournalEntry,
    uiSchema: uiSchema$F
  };
  function parseSection(value2) {
    return {
      code: codeableConcept$1(value2?.code),
      entry: map(value2?.entry, reference$1)
    };
  }
  const uiSchemaGroup$w = (resource, context) => {
    const ui = context.ui;
    const profile2 = "EncounterReport.Section";
    return {
      label: profile2,
      children: [
        ui.codeableConcept(`${profile2}.code`, resource.code),
        ...map(resource.entry, (entry) => ui.reference(`${profile2}.entry`, entry), true)
      ]
    };
  };
  const uiSchema$E = (resource, context) => {
    const ui = context.ui;
    const profile2 = "EncounterReport";
    const section = map(resource.section, (x) => uiSchemaGroup$w(x, context), true);
    return {
      label: resource.title,
      children: [
        {
          label: `${profile2}`,
          children: [
            ui.string(`${profile2}.title`, resource.title),
            ui.string(`${profile2}.status`, resource.status),
            ui.coding(`${profile2}.type`, resource.type),
            ui.reference(`${profile2}.encounter`, resource.encounter),
            ui.dateTime(`${profile2}.date`, resource.date),
            ui.reference(`${profile2}.author`, resource.author)
          ]
        },
        ...section
      ]
    };
  };
  const profile$E = "http://nictiz.nl/fhir/StructureDefinition/gp-EncounterReport";
  function parseGpEncounterReport(resource) {
    return {
      ...resourceMeta(resource, profile$E, FhirVersion.R3),
      identifier: identifier$1(resource.identifier),
      status: string$1(resource.status),
      type: map(resource.type.coding, coding$1),
      encounter: reference$1(resource.encounter),
      date: dateTime$3(resource.date),
      author: map(resource.author, reference$1),
      title: string$1(resource.title),
      section: map(resource.section, parseSection)
    };
  }
  const gpEncounterReport = {
    profile: profile$E,
    parse: parseGpEncounterReport,
    uiSchema: uiSchema$E
  };
  const uiSchemaGroup$v = (resource, { ui, formatMessage: formatMessage2 }) => {
    const i18n = "zib_administration_schedule";
    const { repeat } = resource;
    const hcimInstructionsForUse = {
      DoseDuration: ui.oneOfValueX(`${i18n}.repeat.bounds`, repeat, "bounds"),
      DurationOfAdministration: ui.valueWithUnit(
        `${i18n}.repeat.duration`,
        repeat?.duration,
        repeat?.durationUnit
      ),
      Frequency: ui.integer(`${i18n}.repeat.frequency`, repeat?.frequency),
      FrequencyMax: ui.integer(`${i18n}.repeat.frequency_max`, repeat?.frequencyMax),
      FrequencyOrInterval: ui.valueWithUnit(
        `${i18n}.repeat.period`,
        repeat?.period,
        repeat?.periodUnit
      ),
      WeekDay: ui.string(`${i18n}.repeat.day_of_week`, repeat?.dayOfWeek),
      AdministrationTime: ui.dateTime(`${i18n}.repeat.time_of_day`, repeat?.timeOfDay),
      TimeOfDay: ui.string(`${i18n}.repeat.when`, repeat?.when)
    };
    return {
      label: formatMessage2(i18n),
      children: [
        ...hcimInstructionsForUse.DoseDuration,
        hcimInstructionsForUse.DurationOfAdministration,
        hcimInstructionsForUse.Frequency,
        hcimInstructionsForUse.FrequencyMax,
        hcimInstructionsForUse.FrequencyOrInterval,
        hcimInstructionsForUse.WeekDay,
        hcimInstructionsForUse.AdministrationTime,
        hcimInstructionsForUse.TimeOfDay
      ]
    };
  };
  function parseZibAdministrationSchedule(value2) {
    const { repeat } = value2 ?? {};
    return {
      repeat: {
        ...oneOfValueX$1(repeat, ["duration", "range", "period"], "bounds"),
        duration: decimal$1(repeat?.duration),
        durationUnit: code$1(repeat?.durationUnit),
        frequency: integer$1(repeat?.frequency),
        frequencyMax: integer$1(repeat?.frequencyMax),
        period: decimal$1(repeat?.period),
        periodUnit: code$1(repeat?.periodUnit),
        dayOfWeek: map(repeat?.dayOfWeek, code$1),
        timeOfDay: map(repeat?.timeOfDay, dateTime$3),
        when: map(repeat?.when, code$1)
      }
    };
  }
  const zibAdministrationSchedule = {
    parse: parseZibAdministrationSchedule,
    uiSchemaGroup: uiSchemaGroup$v
  };
  const uiSchemaGroup$u = (resource, context) => {
    const i18n = "zib_instructions_for_use";
    const { ui, formatMessage: formatMessage2 } = context;
    const hcimInstructionsForUse = {
      SequenceNumber: ui.integer(`${i18n}.sequence`, resource.sequence),
      Description: ui.string(`${i18n}.text`, resource.text),
      AdditionalInstructions: ui.codeableConcept(
        `${i18n}.additional_instruction`,
        resource.additionalInstruction
      ),
      AdministeringSchedule: zibAdministrationSchedule.uiSchemaGroup(resource.timing, context),
      AsNeeded: ui.codeableConcept(`${i18n}.as_needed_codeable_concept`, resource.asNeeded),
      RouteOfAdministration: ui.codeableConcept(`${i18n}.route`, resource.route),
      Dose: ui.oneOfValueX(`${i18n}.dose`, resource, "dose"),
      MaximumDose: ui.ratio(`${i18n}.max_dose_per_period`, resource.maxDosePerPeriod),
      AdministeringSpeed: ui.oneOfValueX(`${i18n}.rate`, resource, "rate")
    };
    return [
      {
        label: formatMessage2(i18n),
        children: [
          hcimInstructionsForUse.Description,
          hcimInstructionsForUse.RouteOfAdministration,
          hcimInstructionsForUse.AdditionalInstructions,
          ...hcimInstructionsForUse.AdministeringSpeed,
          hcimInstructionsForUse.SequenceNumber
        ]
      },
      hcimInstructionsForUse.AdministeringSchedule
    ];
  };
  function parseZibInstructionsForUse(value2) {
    return {
      sequence: integer$1(value2?.sequence),
      // NL-CM:9.12.22503
      text: string$1(value2?.text),
      // NL-CM:9.12.9581
      additionalInstruction: map(value2?.additionalInstruction, codeableConcept$1),
      // NL-CM:9.12.19944
      asNeeded: codeableConcept$1(value2?.asNeededCodeableConcept),
      // NL-CM:9.12.22512 | NL-CM:9.12.19945
      route: codeableConcept$1(value2?.route),
      // NL-CM:9.12.19941
      ...oneOfValueX$1(value2, ["range", "quantity"], "dose"),
      // NL-CM:9.12.19940
      maxDosePerPeriod: ratio$1(value2?.maxDosePerPeriod),
      // NL-CM:9.12.19946
      ...oneOfValueX$1(value2, ["ratio", "range", "quantity"], "rate"),
      // NL-CM:9.12.19942
      timing: zibAdministrationSchedule.parse(value2?.timing)
    };
  }
  const zibInstructionsForUse = {
    parse: parseZibInstructionsForUse,
    uiSchemaGroup: uiSchemaGroup$u
  };
  const uiSchemaGroup$t = (resource, context) => {
    const i18n = "zib_product_ingredient";
    const ui = context.ui;
    return {
      label: i18n,
      children: [
        ui.codeableConcept(`${i18n}.item`, resource.item),
        ...ui.ratio(`${i18n}.amount`, resource.amount)
      ]
    };
  };
  function parseZibProductIngredient(value2) {
    return {
      item: codeableConcept$1(value2?.itemCodeableConcept),
      amount: ratio$1(value2?.amount)
    };
  }
  const zibProductIngredient = {
    parse: parseZibProductIngredient,
    uiSchemaGroup: uiSchemaGroup$t
  };
  const uiSchemaGroup$s = (resource, context) => {
    const i18n = "zib_product_package";
    const ui = context.ui;
    const contents = map(
      resource.content,
      (content) => {
        return [
          ui.codeableConcept(`${i18n}.content_item`, content.item),
          ui.reference(`${i18n}.content_reference`, content.reference)
        ];
      },
      true
    );
    return {
      label: i18n,
      children: [...contents.flat()]
    };
  };
  function parseZibProductPackage(value2) {
    return {
      content: map(value2?.content, ({ itemCodeableConcept, itemReference }) => ({
        item: codeableConcept$1(itemCodeableConcept),
        reference: reference$1(itemReference)
      }))
    };
  }
  const zibProductPackage = {
    parse: parseZibProductPackage,
    uiSchemaGroup: uiSchemaGroup$s
  };
  const uiSchemaGroup$r = (resource, context) => {
    const i18n = "nl_core_address";
    const ui = context.ui;
    return {
      label: i18n,
      children: [
        ui.string(`${i18n}.use`, resource?.use),
        ui.string(`${i18n}.type`, resource?.type),
        ui.string(`${i18n}.text`, resource?.text),
        ui.string(`${i18n}.city`, resource?.city),
        ui.string(`${i18n}.district`, resource?.district),
        ui.string(`${i18n}.state`, resource?.state),
        ui.string(`${i18n}.postalCode`, resource?.postalCode),
        ui.string(`${i18n}.country`, resource?.country),
        ...ui.period(`${i18n}.period`, resource?.period)
      ]
    };
  };
  function parseNlCoreAddress(value2) {
    return {
      use: code$1(value2?.use),
      type: code$1(value2?.type),
      text: string$1(value2?.text),
      line: map(value2?.line, string$1),
      city: string$1(value2?.city),
      district: string$1(value2?.district),
      state: string$1(value2?.state),
      postalCode: string$1(value2?.postalCode),
      country: string$1(value2?.country),
      period: period$1(value2?.period)
    };
  }
  const nlCoreAddress = {
    parse: parseNlCoreAddress,
    uiSchemaGroup: uiSchemaGroup$r
  };
  const uiSchemaGroup$q = (resource, context) => {
    const i18n = "nl_core_contact_point";
    const ui = context.ui;
    return {
      label: i18n,
      children: [
        ui.string(`${i18n}.system`, resource?.system),
        ui.string(`${i18n}.value`, resource?.value),
        ui.string(`${i18n}.use`, resource?.use),
        ui.positiveInt(`${i18n}.rank`, resource?.rank),
        ...ui.period(`${i18n}.period`, resource.period)
      ]
    };
  };
  function parseNlCoreContactpoint(value2) {
    return {
      system: code$1(value2?.system),
      value: string$1(value2?.value),
      use: code$1(value2?.use),
      rank: positiveInt$1(value2?.rank),
      period: period$1(value2?.period)
    };
  }
  const nlCoreContactpoint = {
    parse: parseNlCoreContactpoint,
    uiSchemaGroup: uiSchemaGroup$q
  };
  const uiSchemaGroup$p = (resource, context) => {
    const i18n = "nl_core_humanname";
    const ui = context.ui;
    return {
      label: i18n,
      children: [
        ui.string(`${i18n}.family`, resource?.family),
        ui.string(`${i18n}.given`, resource?.given),
        ...ui.period(`${i18n}.period`, resource?.period),
        ui.string(`${i18n}.prefix`, resource?.prefix),
        ui.string(`${i18n}.suffix`, resource?.suffix),
        ui.string(`${i18n}.use`, resource?.use),
        ui.string(`${i18n}.text`, resource?.text)
      ]
    };
  };
  function parseNlCoreHumanname(value2) {
    return {
      family: string$1(value2?.family),
      given: map(value2?.given, string$1),
      period: period$1(value2?.period),
      prefix: map(value2?.prefix, string$1),
      suffix: map(value2?.suffix, string$1),
      text: string$1(value2?.text),
      use: string$1(value2?.use)
    };
  }
  const nlCoreHumanname = {
    parse: parseNlCoreHumanname,
    uiSchemaGroup: uiSchemaGroup$p
  };
  const uiSchemaGroup$o = (resource, context) => {
    const i18n = "attachment";
    const ui = context.ui;
    return {
      label: i18n,
      children: [
        ui.string(`${i18n}.contentType`, resource.contentType),
        ui.string(`${i18n}.language`, resource.language),
        ui.string(`${i18n}.data`, resource.data),
        ui.string(`${i18n}.url`, resource.url),
        ui.unsignedInt(`${i18n}.size`, resource.size),
        ui.string(`${i18n}.hash`, resource.hash),
        ui.string(`${i18n}.title`, resource.title),
        ui.dateTime(`${i18n}.creation`, resource.creation)
      ]
    };
  };
  function parseAttachment(value2) {
    return {
      contentType: code$1(value2?.contentType),
      language: code$1(value2?.language),
      data: string$1(value2?.data),
      url: string$1(value2?.url),
      size: unsignedInt$1(value2?.size),
      hash: string$1(value2?.hash),
      title: string$1(value2?.title),
      creation: dateTime$3(value2?.creation)
    };
  }
  const attachment = {
    parse: parseAttachment,
    uiSchemaGroup: uiSchemaGroup$o
  };
  const uiSchemaGroup$n = (resource, context) => {
    const i18n = "nl_core_patient.communication";
    const ui = context.ui;
    return {
      label: i18n,
      children: [
        ui.codeableConcept(`${i18n}.language`, resource.language),
        ui.boolean(`${i18n}.preferred`, resource.preferred)
      ]
    };
  };
  function parseCommunication(value2) {
    return {
      language: codeableConcept$1(value2?.language),
      preferred: boolean$1(value2?.preferred)
    };
  }
  const communication = {
    parse: parseCommunication,
    uiSchemaGroup: uiSchemaGroup$n
  };
  const uiSchemaGroup$m = (resource, context) => {
    const i18n = "nl_core_patient.contact";
    const ui = context.ui;
    const telecom = map(
      resource.telecom,
      (x) => nlCoreContactpoint.uiSchemaGroup(x, context),
      true
    ).flat();
    return {
      label: i18n,
      children: [
        ...nlCoreHumanname.uiSchemaGroup(resource.name, context).children,
        ...ui.helpers.getChildren(telecom),
        ...nlCoreAddress.uiSchemaGroup(resource.address, context).children,
        ui.string(`${i18n}.gender`, resource.gender),
        ui.reference(`${i18n}.organization`, resource.organization),
        ...ui.period(`${i18n}.period`, resource.period)
      ].filter(isNonNullish)
    };
  };
  function parseContact(value2) {
    return {
      relationship: map(value2?.relationship, codeableConcept$1, true),
      name: nlCoreHumanname.parse(value2?.name),
      telecom: map(value2?.telecom, nlCoreContactpoint.parse, true),
      address: nlCoreAddress.parse(value2?.address),
      gender: code$1(value2?.gender),
      organization: reference$1(value2?.organization),
      period: period$1(value2?.period)
    };
  }
  const contact = {
    parse: parseContact,
    uiSchemaGroup: uiSchemaGroup$m
  };
  const uiSchemaGroup$l = (resource, context) => {
    const i18n = "nl_core_patient.link";
    const ui = context.ui;
    return {
      label: i18n,
      children: [
        ui.reference(`${i18n}.other`, resource.other),
        ui.code(`${i18n}.type`, resource.type)
      ]
    };
  };
  function parseLink(value2) {
    return {
      other: reference$1(value2?.other),
      type: code$1(value2?.type)
    };
  }
  const link = {
    parse: parseLink,
    uiSchemaGroup: uiSchemaGroup$l
  };
  const uiSchema$D = (resource, context) => {
    const ui = context.ui;
    const i18n = "nl_core_patient";
    const address = map(resource.address, (x) => nlCoreAddress.uiSchemaGroup(x, context), true);
    const communication2 = map(
      resource.communication,
      (x) => uiSchemaGroup$n(x, context),
      true
    );
    const contact2 = map(resource.contact, (x) => uiSchemaGroup$m(x, context), true);
    const link2 = map(resource.link, (x) => uiSchemaGroup$l(x, context), true);
    const name = map(resource.name, (x) => nlCoreHumanname.uiSchemaGroup(x, context), true);
    const photo = map(resource.photo, (x) => uiSchemaGroup$o(x, context), true);
    const telecom = map(
      resource.telecom,
      (x) => nlCoreContactpoint.uiSchemaGroup(x, context),
      true
    );
    return {
      label: resource.name?.at(0)?.text,
      children: [
        {
          label: `${i18n}.group_details`,
          children: [
            ui.boolean(`${i18n}.active`, resource.active),
            ui.date(`${i18n}.birth_date`, resource.birthDate),
            ui.boolean(`${i18n}.deceased`, resource.deceased),
            ui.dateTime(`${i18n}.deceased_date_time`, resource.deceasedDateTime),
            ui.code(`${i18n}.gender`, resource.gender),
            ui.reference(`${i18n}.general_practitioner`, resource.generalPractitioner),
            ui.identifier(`${i18n}.identifier`, resource.identifier),
            ui.reference(`${i18n}.managing_organization`, resource.managingOrganization),
            ui.codeableConcept(`${i18n}.marital_status`, resource.maritalStatus),
            ui.boolean(`${i18n}.multiple_birth`, resource.multipleBirth),
            ui.integer(`${i18n}.multiple_birth_integer`, resource.multipleBirthInteger)
          ]
        },
        ...address,
        ...communication2,
        ...contact2,
        ...link2,
        ...name,
        ...photo,
        ...telecom
      ]
    };
  };
  const profile$D = "http://fhir.nl/fhir/StructureDefinition/nl-core-patient";
  function parseNlCorePatient$1(resource) {
    return {
      ...resourceMeta(resource, profile$D, FhirVersion.R3),
      active: boolean$1(resource.active),
      address: map(resource.address, nlCoreAddress.parse),
      birthDate: date$4(resource.birthDate),
      communication: map(resource.communication, communication.parse),
      contact: map(resource.contact, contact.parse),
      deceased: boolean$1(resource.deceasedBoolean),
      deceasedDateTime: dateTime$3(resource.deceasedDateTime),
      gender: code$1(resource.gender),
      generalPractitioner: map(resource.generalPractitioner, reference$1),
      identifier: map(resource.identifier, identifier$1),
      link: map(resource.link, link.parse),
      managingOrganization: reference$1(resource.managingOrganization),
      maritalStatus: codeableConcept$1(resource.maritalStatus),
      multipleBirth: boolean$1(resource.multipleBirthBoolean),
      multipleBirthInteger: integer$1(resource.multipleBirthInteger),
      name: map(resource.name, nlCoreHumanname.parse),
      photo: map(resource.photo, attachment.parse),
      telecom: map(resource.telecom, nlCoreContactpoint.parse)
    };
  }
  const nlCorePatient = {
    profile: profile$D,
    parse: parseNlCorePatient$1,
    uiSchema: uiSchema$D
  };
  const uiSchema$C = (resource, context) => {
    const ui = context.ui;
    const profile2 = "nl_core_organization";
    const address = map(
      resource.address,
      (x) => nlCoreAddress.uiSchemaGroup(x, context),
      true
    ).flat();
    const telecom = map(
      resource.telecom,
      (x) => nlCoreContactpoint.uiSchemaGroup(x, context),
      true
    ).flat();
    return {
      label: resource.name,
      children: [
        {
          label: `${profile2}.group_details`,
          children: [
            ui.identifier(`${profile2}.identifier`, resource.identifier),
            ui.string(`${profile2}.name`, resource.name),
            ui.codeableConcept(
              `${profile2}.department_specialty`,
              resource.departmentSpecialty
            ),
            ui.codeableConcept(`${profile2}.organization_type`, resource.organizationType)
          ]
        },
        ...address,
        ...telecom
      ]
    };
  };
  const profile$C = "http://fhir.nl/fhir/StructureDefinition/nl-core-organization";
  function parseNlCoreOrganization(resource) {
    return {
      ...resourceMeta(resource, profile$C, FhirVersion.R3),
      identifier: map(resource.identifier, identifier$1),
      name: string$1(resource.name),
      departmentSpecialty: map(
        filterCodeableConceptByCoding(
          resource.type,
          (x) => x.system === "urn:oid:2.16.840.1.113883.2.4.6.7"
        ),
        codeableConcept$1
      ),
      telecom: map(resource.telecom, nlCoreContactpoint.parse),
      address: map(resource.address, nlCoreAddress.parse),
      organizationType: map(
        filterCodeableConceptByCoding(
          resource.type,
          (x) => x.system === "http://nictiz.nl/fhir/NamingSystem/organization-type"
          // NOSONAR
        ),
        codeableConcept$1
      )
    };
  }
  const nlCoreOrganization = {
    profile: profile$C,
    parse: parseNlCoreOrganization,
    uiSchema: uiSchema$C
  };
  const uiSchema$B = (resource, context) => {
    const ui = context.ui;
    const profile2 = "nl_core_practitioner";
    const address = map(resource.address, (x) => nlCoreAddress.uiSchemaGroup(x, context), true);
    const name = map(resource.name, (x) => nlCoreHumanname.uiSchemaGroup(x, context), true);
    const telecom = map(
      resource.telecom,
      (x) => nlCoreContactpoint.uiSchemaGroup(x, context),
      true
    );
    return {
      label: resource.name?.at(0)?.text,
      children: [
        {
          label: `${profile2}.group_details`,
          children: [ui.identifier(`${profile2}.identifier`, resource.identifier)]
        },
        ...address,
        ...name,
        ...telecom
      ]
    };
  };
  const profile$B = "http://fhir.nl/fhir/StructureDefinition/nl-core-practitioner";
  function parseNlCorePractitioner(resource) {
    return {
      ...resourceMeta(resource, profile$B, FhirVersion.R3),
      identifier: map(resource.identifier, identifier$1),
      name: map(resource.name, nlCoreHumanname.parse),
      address: map(resource.address, nlCoreAddress.parse),
      telecom: map(resource.telecom, nlCoreContactpoint.parse)
    };
  }
  const nlCorePractitioner = {
    profile: profile$B,
    parse: parseNlCorePractitioner,
    uiSchema: uiSchema$B
  };
  const uiSchema$A = (resource, context) => {
    const ui = context.ui;
    const profile2 = "nl_core_practitionerrole";
    const telecom = map(
      resource.telecom,
      (x) => nlCoreContactpoint.uiSchemaGroup(x, context),
      true
    );
    return {
      label: resource.identifier?.at(0)?.value,
      children: [
        {
          label: `${profile2}.group_details`,
          children: [
            ui.identifier(`${profile2}.identifier`, resource.identifier),
            ui.reference(`${profile2}.organization`, resource.organization),
            ui.codeableConcept(`${profile2}.specialty`, resource.specialty)
          ]
        },
        ...telecom
      ]
    };
  };
  const profile$A = "http://fhir.nl/fhir/StructureDefinition/nl-core-practitionerrole";
  function parseNlCorePractitionerRole(resource) {
    return {
      ...resourceMeta(resource, profile$A, FhirVersion.R3),
      identifier: map(resource.identifier, identifier$1),
      organization: reference$1(resource.organization),
      specialty: map(resource.specialty, codeableConcept$1),
      telecom: map(resource.telecom, nlCoreContactpoint.parse)
    };
  }
  const nlCorePractitionerRole = {
    profile: profile$A,
    parse: parseNlCorePractitionerRole,
    uiSchema: uiSchema$A
  };
  const uiSchema$z = (resource, context) => {
    const ui = context.ui;
    const i18n = "zib_alert";
    return {
      label: i18n,
      children: [
        {
          label: `${i18n}.group_general_information`,
          children: [
            ui.identifier(`${i18n}.identifier`, resource.identifier),
            ui.code(`${i18n}.status`, resource.status),
            ui.codeableConcept(`${i18n}.category`, resource.category),
            ui.codeableConcept(`${i18n}.code`, resource.code),
            ui.reference(`${i18n}.subject`, resource.subject),
            ...ui.period(`${i18n}.period`, resource.period),
            ui.reference(`${i18n}.encounter`, resource.encounter),
            ui.reference(`${i18n}.author`, resource.author)
          ]
        }
      ]
    };
  };
  const profile$z = "http://nictiz.nl/fhir/StructureDefinition/zib-Alert";
  function parseZibAlert(resource) {
    return {
      ...resourceMeta(resource, profile$z, FhirVersion.R3),
      identifier: map(resource.identifier, identifier$1),
      status: code$1(resource.status),
      category: codeableConcept$1(resource.category),
      code: codeableConcept$1(resource.code),
      subject: reference$1(resource.subject),
      period: period$1(resource.period),
      encounter: reference$1(resource.encounter),
      author: reference$1(resource.author)
    };
  }
  const zibAlert = {
    profile: profile$z,
    parse: parseZibAlert,
    uiSchema: uiSchema$z
  };
  const uiSchema$y = (resource, context) => {
    const ui = context.ui;
    const i18n = "zib_administration_agreement";
    const instructionsForUse = map(
      resource.dossageInstruction,
      (x) => uiSchemaGroup$u(x, context),
      true
    ).flat();
    return {
      label: resource.medicationReference?.display,
      children: [
        {
          label: `${i18n}.group_general_information`,
          children: [
            ui.dateTime(`${i18n}.authored_on`, resource.authoredOn),
            ui.string(`${i18n}.agreement_reason`, resource.agreementReason),
            ui.duration(`${i18n}.usage_duration`, resource.usageDuration),
            ui.codeableConcept(
              `${i18n}.additional_information`,
              resource.additionalInformation
            ),
            ui.identifier(`${i18n}.medication_treatment`, resource.medicationTreatment),
            ui.codeableConcept(`${i18n}.stop_type`, resource.stopType),
            ui.duration(
              `${i18n}.repeat_period_cyclical_schedule`,
              resource.repeatPeriodCyclicalSchedule
            ),
            ui.identifier(`${i18n}.identifier`, resource.identifier),
            ui.code(`${i18n}.status`, resource.status),
            ui.codeableConcept(`${i18n}.category`, resource.category),
            ui.quantity(`${i18n}.quantity`, resource.quantity),
            ui.quantity(`${i18n}.days_supply`, resource.daysSupply),
            ui.annotation(`${i18n}.note`, resource.note)
          ]
        },
        ...instructionsForUse
      ]
    };
  };
  const profile$y = "http://nictiz.nl/fhir/StructureDefinition/zib-AdministrationAgreement";
  function parseZibAdministrationAgreement(resource) {
    return {
      ...resourceMeta(resource, profile$y, FhirVersion.R3),
      authoredOn: extensionNictiz(resource, "zib-AdministrationAgreement-AuthoredOn"),
      agreementReason: extensionNictiz(
        resource,
        "zib-AdministrationAgreement-AgreementReason"
      ),
      usageDuration: extensionNictiz(resource, "zib-MedicationUse-Duration"),
      additionalInformation: extensionNictiz(
        resource,
        "zib-Medication-AdditionalInformation"
      ),
      medicationTreatment: extensionNictiz(resource, "zib-Medication-MedicationTreatment"),
      stopType: extensionNictiz(resource, "zib-Medication-StopType"),
      repeatPeriodCyclicalSchedule: extensionNictiz(
        resource,
        "zib-Medication-RepeatPeriodCyclicalSchedule"
      ),
      identifier: map(resource.identifier, identifier$1),
      status: code$1(resource.status),
      category: codeableConcept$1(resource.category),
      medicationReference: reference$1(resource.medicationReference),
      quantity: quantity$1(resource.quantity),
      daysSupply: quantity$1(resource.daysSupply),
      note: map(resource.note, annotation$1),
      dossageInstruction: map(resource.dosageInstruction, zibInstructionsForUse.parse)
    };
  }
  const zibAdministrationAgreement = {
    profile: profile$y,
    parse: parseZibAdministrationAgreement,
    uiSchema: uiSchema$y
  };
  const uiSchema$x = (resource, context) => {
    const ui = context.ui;
    const i18n = "zib_medication_agreement";
    const instructionsForUse = map(
      resource.dossageInstruction,
      (x) => uiSchemaGroup$u(x, context),
      true
    ).flat();
    return {
      label: resource.medicationReference?.display,
      children: [
        {
          label: `${i18n}.group_general_information`,
          children: [
            ...ui.period(`${i18n}.period_of_use`, resource.periodOfUse),
            ui.duration(`${i18n}.usage_duration`, resource.usageDuration),
            ui.identifier(`${i18n}.medication_treatment`, resource.medicationTreatment),
            ui.codeableConcept(`${i18n}.stop_type`, resource.stopType),
            ui.duration(
              `${i18n}.repeat_period_cyclical_schedule`,
              resource.repeatPeriodCyclicalSchedule
            ),
            ui.identifier(`${i18n}.identifier`, resource.identifier),
            ui.reference(`${i18n}.definition`, resource.definition),
            ui.reference(`${i18n}.basedOn`, resource.basedOn),
            ui.identifier(`${i18n}.group_identifier`, resource.groupIdentifier),
            ui.code(`${i18n}.status`, resource.status),
            ui.code(`${i18n}.intent`, resource.intent),
            ui.codeableConcept(`${i18n}.category`, resource.category),
            ui.code(`${i18n}.priority`, resource.priority),
            ui.reference(`${i18n}.medication_reference`, resource.medicationReference),
            ui.annotation(`${i18n}.note`, resource.note)
          ]
        },
        ...instructionsForUse
      ]
    };
  };
  const profile$x = "http://nictiz.nl/fhir/StructureDefinition/zib-MedicationAgreement";
  function parseZibMedicationAgreement(resource) {
    return {
      ...resourceMeta(resource, profile$x, FhirVersion.R3),
      periodOfUse: extensionNictiz(resource, "zib-Medication-PeriodOfUse"),
      usageDuration: extensionNictiz(resource, "zib-MedicationUse-Duration"),
      medicationTreatment: extensionNictiz(resource, "zib-Medication-MedicationTreatment"),
      stopType: extensionNictiz(resource, "zib-Medication-StopType"),
      repeatPeriodCyclicalSchedule: extensionNictiz(
        resource,
        "zib-Medication-RepeatPeriodCyclicalSchedule"
      ),
      identifier: map(resource.identifier, identifier$1),
      definition: map(resource.definition, reference$1),
      basedOn: map(resource.basedOn, reference$1),
      groupIdentifier: identifier$1(resource.groupIdentifier),
      status: code$1(resource.status),
      intent: code$1(resource.intent),
      category: codeableConcept$1(resource.category),
      priority: code$1(resource.priority),
      medicationReference: reference$1(resource.medicationReference),
      note: map(resource.note, annotation$1),
      dossageInstruction: map(resource.dosageInstruction, zibInstructionsForUse.parse)
    };
  }
  const zibMedicationAgreement = {
    profile: profile$x,
    parse: parseZibMedicationAgreement,
    uiSchema: uiSchema$x
  };
  const uiSchema$w = (resource, context) => {
    const ui = context.ui;
    const i18n = "zib_allergy_intolerance";
    return {
      label: resource.identifier?.at(0)?.value,
      children: [
        {
          label: `${i18n}.group_details`,
          children: [
            ui.identifier(`${i18n}.identifier`, resource.identifier),
            ui.code(`${i18n}.clinical_status`, resource.clinicalStatus),
            ui.code(`${i18n}.verification_status`, resource.verificationStatus),
            ui.code(`${i18n}.type`, resource.type),
            ui.code(`${i18n}.category`, resource.category),
            ui.code(`${i18n}.criticality`, resource.criticality),
            ui.codeableConcept(`${i18n}.code`, resource.code),
            ui.reference(`${i18n}.patient`, resource.patient)
          ]
        }
      ]
    };
  };
  const profile$w = "http://nictiz.nl/fhir/StructureDefinition/zib-AllergyIntolerance";
  function parseZibAllergyIntolerance(resource) {
    return {
      ...resourceMeta(resource, profile$w, FhirVersion.R3),
      identifier: map(resource.identifier, identifier$1),
      clinicalStatus: code$1(resource.clinicalStatus),
      verificationStatus: code$1(resource.verificationStatus),
      type: code$1(resource.type),
      category: map(resource.category, code$1),
      criticality: code$1(resource.criticality),
      code: codeableConcept$1(resource.code),
      patient: reference$1(resource.patient)
    };
  }
  const zibAllergyIntolerance = {
    profile: profile$w,
    parse: parseZibAllergyIntolerance,
    uiSchema: uiSchema$w
  };
  const uiSchema$v = (resource, context) => {
    const i18n = "zib_medication_use";
    const { ui, formatMessage: formatMessage2, setEmptyEntries: setEmptyEntries2 } = context;
    const hcimMedicationUse2 = {
      AsAgreedIndicator: ui.boolean(`${i18n}.as_agreed_indicator`, resource.asAgreedIndicator),
      Prescriber: ui.reference(`${i18n}.prescriber`, resource.prescriber),
      ReasonForChangeOrDiscontinuationOfUse: ui.codeableConcept(
        `${i18n}.reason_for_change_or_discontinuation_of_use`,
        resource.reasonForChangeOrDiscontinuationOfUse
      ),
      MedicationUseStopType: ui.code(`${i18n}.status`, resource.status),
      ProductUsed: ui.reference(`${i18n}.medication_reference`, resource.medicationReference),
      PeriodOfUsePeriod: ui.period(`${i18n}.effective_period`, resource.effectivePeriod),
      PeriodOfUseDuration: ui.duration(
        `${i18n}.effective_period.duration`,
        resource.effectiveDuration
      ),
      MedicationUseDateTime: ui.dateTime(`${i18n}.date_asserted`, resource.dateAsserted),
      UseIndicator: ui.code(`${i18n}.taken`, resource.taken),
      ReasonForUse: ui.codeableConcept(`${i18n}.reason_code.text`, resource.reasonCode),
      Comment: ui.annotation(`${i18n}.note`, resource.note)
    };
    const hcimInstructionsForUse = {
      InstructionsForUse: map(
        resource.dosage,
        (x) => uiSchemaGroup$u(x, context),
        true
      ).flat(),
      RepeatPeriodCyclicalSchedule: ui.duration(
        `${i18n}.repeat_period_cyclical_schedule`,
        resource.repeatPeriodCyclicalSchedule
      )
    };
    return setEmptyEntries2({
      label: resource.medicationReference?.display,
      children: [
        {
          label: formatMessage2(`fhir.group_general_info`),
          children: [
            hcimMedicationUse2.ProductUsed,
            hcimMedicationUse2.MedicationUseDateTime,
            ...hcimMedicationUse2.PeriodOfUsePeriod,
            hcimMedicationUse2.PeriodOfUseDuration,
            hcimMedicationUse2.Prescriber,
            hcimMedicationUse2.ReasonForUse,
            hcimMedicationUse2.AsAgreedIndicator,
            hcimMedicationUse2.UseIndicator,
            hcimMedicationUse2.MedicationUseStopType,
            hcimMedicationUse2.ReasonForChangeOrDiscontinuationOfUse,
            hcimInstructionsForUse.RepeatPeriodCyclicalSchedule,
            ui.identifier(`${i18n}.medication_treatment`, resource.medicationTreatment),
            hcimMedicationUse2.Comment
          ]
        },
        ...hcimInstructionsForUse.InstructionsForUse.flat()
      ]
    });
  };
  const profile$v = "http://nictiz.nl/fhir/StructureDefinition/zib-MedicationUse";
  function parseZibMedicationUse(resource) {
    return {
      ...resourceMeta(resource, profile$v, FhirVersion.R3),
      asAgreedIndicator: extensionNictiz(resource, "zib-MedicationUse-AsAgreedIndicator"),
      prescriber: extensionNictiz(resource, "zib-MedicationUse-Prescriber"),
      author: extensionNictiz(resource, "zib-MedicationUse-Author"),
      medicationTreatment: extensionNictiz(resource, "zib-Medication-MedicationTreatment"),
      reasonForChangeOrDiscontinuationOfUse: extensionNictiz(
        resource,
        "zib-MedicationUse-ReasonForChangeOrDiscontinuationOfUse"
      ),
      repeatPeriodCyclicalSchedule: extensionNictiz(
        resource,
        "zib-Medication-RepeatPeriodCyclicalSchedule"
      ),
      identifier: map(resource.identifier, identifier$1),
      status: code$1(resource.status),
      category: codeableConcept$1(resource.category),
      medicationReference: reference$1(resource.medicationReference),
      effectivePeriod: period$1(resource.effectivePeriod),
      effectiveDuration: extensionNictiz(
        resource.effectivePeriod,
        "zib-MedicationUse-Duration"
      ),
      dateAsserted: dateTime$3(resource.dateAsserted),
      informationSource: reference$1(resource.informationSource),
      subject: reference$1(resource.subject),
      taken: code$1(resource.taken),
      reasonCode: map(resource.reasonCode, codeableConcept$1),
      note: map(resource.note, annotation$1),
      dosage: map(resource.dosage, zibInstructionsForUse.parse)
    };
  }
  const zibMedicationUse = {
    profile: profile$v,
    parse: parseZibMedicationUse,
    uiSchema: uiSchema$v
  };
  const uiSchema$u = (resource, context) => {
    const ui = context.ui;
    const i18n = "zib_medical_device";
    return {
      label: resource.device?.display,
      children: [
        {
          label: `${i18n}.group_product`,
          children: [
            ui.identifier(`${i18n}.identifier`, resource.identifier),
            ui.code(`${i18n}.clinical_status`, resource.status),
            ui.reference(`${i18n}.device`, resource.device),
            ...ui.period(`${i18n}.whenUsed`, resource.whenUsed),
            ui.dateTime(`${i18n}.recordedOn`, resource.recordedOn)
          ]
        },
        {
          label: `${i18n}.group_indication`,
          children: [
            ui.annotation(`${i18n}.note`, resource.note),
            ui.codeableConcept(`${i18n}.bodySite`, resource.bodySite),
            ui.codeableConcept(`${i18n}.laterality`, resource.laterality),
            ui.reference(`${i18n}.reason`, resource.reason)
          ]
        },
        {
          label: `${i18n}.group_general`,
          children: [
            ui.reference(`${i18n}.patient`, resource.patient),
            ui.reference(`${i18n}.source`, resource.source),
            ui.reference(`${i18n}.organization`, resource.organization),
            ui.reference(`${i18n}.practitioner`, resource.practitioner)
          ]
        }
      ]
    };
  };
  const profile$u = "http://nictiz.nl/fhir/StructureDefinition/zib-MedicalDevice";
  function parseZibMedicalDevice(resource) {
    return {
      ...resourceMeta(resource, profile$u, FhirVersion.R3),
      identifier: map(resource.identifier, identifier$1),
      organization: extensionNictiz(resource, "zib-MedicalDevice-Organization"),
      practitioner: extensionNictiz(resource, "zib-MedicalDevice-Practitioner"),
      reason: extensionNictiz(resource, "deviceUseStatement-reasonReferenceSTU3"),
      status: code$1(resource.status),
      patient: reference$1(resource.subject),
      whenUsed: period$1(resource.whenUsed),
      // timing
      recordedOn: dateTime$3(resource.recordedOn),
      source: reference$1(resource.source),
      device: reference$1(resource.device),
      // indication
      bodySite: codeableConcept$1(resource.bodySite),
      laterality: extensionNictiz(resource.bodySite, "BodySite-Qualifier"),
      note: map(resource.note, annotation$1)
    };
  }
  const zibMedicalDevice = {
    profile: profile$u,
    parse: parseZibMedicalDevice,
    uiSchema: uiSchema$u
  };
  const uiSchemaGroup$k = (resource, context) => {
    const i18n = "zib_payer.grouping";
    const ui = context.ui;
    return {
      label: i18n,
      children: [
        ui.string(`${i18n}.group`, resource.groupDisplay),
        ui.string(`${i18n}.sub_group`, resource.subGroupDisplay),
        ui.string(`${i18n}.plan`, resource.planDisplay),
        ui.string(`${i18n}.sub_plan`, resource.subPlanDisplay),
        ui.string(`${i18n}.class`, resource.classDisplay),
        ui.string(`${i18n}.sub_class`, resource.subClassDisplay)
      ]
    };
  };
  function parseGrouping(value2) {
    return {
      group: string$1(value2?.group),
      groupDisplay: string$1(value2?.groupDisplay),
      subGroup: string$1(value2?.subGroup),
      subGroupDisplay: string$1(value2?.subGroupDisplay),
      plan: string$1(value2?.plan),
      planDisplay: string$1(value2?.planDisplay),
      subPlan: string$1(value2?.subPlan),
      subPlanDisplay: string$1(value2?.subPlanDisplay),
      class: string$1(value2?.class),
      classDisplay: string$1(value2?.classDisplay),
      subClass: string$1(value2?.subClass),
      subClassDisplay: string$1(value2?.subClassDisplay)
    };
  }
  const grouping = {
    parse: parseGrouping,
    uiSchemaGroup: uiSchemaGroup$k
  };
  const uiSchema$t = (resource, context) => {
    const ui = context.ui;
    const i18n = "zib_payer";
    return {
      label: resource.identifier?.at(0)?.value,
      children: [
        {
          label: `${i18n}.group_details`,
          children: [
            ui.identifier(`${i18n}.identifier`, resource.identifier),
            ui.code(`${i18n}.status`, resource.status),
            ui.codeableConcept(`${i18n}.type`, resource.type),
            ui.reference(`${i18n}.policy_holder`, resource.policyHolder),
            ui.reference(`${i18n}.subscriber`, resource.subscriber),
            ui.string(`${i18n}.subscriber_id`, resource.subscriberId),
            ui.reference(`${i18n}.beneficiary`, resource.beneficiary),
            ui.codeableConcept(`${i18n}.relationship`, resource.relationship),
            ...ui.period(`${i18n}.period`, resource.period),
            ui.reference(`${i18n}.payor`, resource.payor),
            ui.string(`${i18n}.dependent`, resource.dependent),
            ui.string(`${i18n}.sequence`, resource.sequence),
            ui.positiveInt(`${i18n}.order`, resource.order),
            ui.string(`${i18n}.network`, resource.network),
            ui.reference(`${i18n}.contract`, resource.contract)
          ]
        },
        uiSchemaGroup$k(resource.grouping, context)
      ]
    };
  };
  const profile$t = "http://nictiz.nl/fhir/StructureDefinition/zib-Payer";
  function parseZibPayer(resource) {
    return {
      ...resourceMeta(resource, profile$t, FhirVersion.R3),
      identifier: map(resource.identifier, identifier$1),
      status: code$1(resource.status),
      type: codeableConcept$1(resource.type),
      policyHolder: reference$1(resource.policyHolder),
      subscriber: reference$1(resource.subscriber),
      subscriberId: string$1(resource.subscriberId),
      beneficiary: reference$1(resource.beneficiary),
      relationship: codeableConcept$1(resource.relationship),
      period: period$1(resource.period),
      payor: map(resource.payor, reference$1),
      grouping: grouping.parse(resource.grouping),
      dependent: string$1(resource.dependent),
      sequence: string$1(resource.sequence),
      order: positiveInt$1(resource.order),
      network: string$1(resource.network),
      contract: map(resource.contract, reference$1)
    };
  }
  const zibPayer = {
    profile: profile$t,
    parse: parseZibPayer,
    uiSchema: uiSchema$t
  };
  const uiSchemaGroup$j = (resource, context) => {
    const i18n = "evidence";
    const ui = context.ui;
    return {
      label: i18n,
      children: [
        ui.codeableConcept(`${i18n}.code`, resource.code),
        ui.reference(`${i18n}.detail`, resource.detail)
      ]
    };
  };
  function parseEvidence(value2) {
    return {
      code: map(value2?.code, codeableConcept$1),
      detail: map(value2?.detail, reference$1)
    };
  }
  const evidence = {
    parse: parseEvidence,
    uiSchemaGroup: uiSchemaGroup$j
  };
  const uiSchemaGroup$i = (resource, context) => {
    const i18n = "stage";
    const ui = context.ui;
    return {
      label: i18n,
      children: [
        ui.codeableConcept(`${i18n}.summary`, resource.summary),
        ui.reference(`${i18n}.assessment`, resource.assessment)
      ]
    };
  };
  function parseStage(value2) {
    return {
      summary: codeableConcept$1(value2?.summary),
      assessment: map(value2?.assessment, reference$1)
    };
  }
  const stage = {
    parse: parseStage,
    uiSchemaGroup: uiSchemaGroup$i
  };
  const uiSchema$s = (resource, context) => {
    const ui = context.ui;
    const i18n = "zib_problem";
    const stage2 = uiSchemaGroup$i(resource.stage, context);
    const evidence2 = map(resource.evidence, (x) => uiSchemaGroup$j(x, context), true);
    return {
      label: resource.code?.coding?.at(0)?.display,
      children: [
        {
          label: `${i18n}.group_general_information`,
          children: [
            ui.code(`${i18n}.clinicalStatus`, resource.clinicalStatus),
            ui.codeableConcept(`${i18n}.category`, resource.category),
            ui.dateTime(`${i18n}.onsetDateTime`, resource.onsetDateTime),
            ui.dateTime(`${i18n}.abatementDateTime`, resource.abatementDateTime),
            ui.codeableConcept(`${i18n}.bodySite`, resource.bodySite),
            ui.annotation(`${i18n}.note`, resource.note)
          ]
        },
        {
          label: `${i18n}.group_others`,
          children: [
            ui.identifier(`${i18n}.identifier`, resource.identifier),
            ui.code(`${i18n}.verificationStatus`, resource.verificationStatus),
            ui.codeableConcept(`${i18n}.severity`, resource.severity),
            ui.codeableConcept(`${i18n}.code`, resource.code),
            ui.reference(`${i18n}.subject`, resource.subject),
            ui.reference(`${i18n}.context`, resource.context),
            ui.dateTime(`${i18n}.assertedDate`, resource.assertedDate),
            ui.reference(`${i18n}.asserter`, resource.asserter)
          ]
        },
        stage2,
        ...evidence2
      ]
    };
  };
  const profile$s = "http://nictiz.nl/fhir/StructureDefinition/zib-Problem";
  function parseZibProblem(resource) {
    return {
      ...resourceMeta(resource, profile$s, FhirVersion.R3),
      identifier: map(resource.identifier, identifier$1),
      clinicalStatus: code$1(resource.clinicalStatus),
      verificationStatus: code$1(resource.verificationStatus),
      category: map(resource.category, codeableConcept$1),
      severity: codeableConcept$1(resource.severity),
      code: codeableConcept$1(resource.code),
      bodySite: map(resource.bodySite, codeableConcept$1),
      subject: reference$1(resource.subject),
      context: reference$1(resource.context),
      onsetDateTime: dateTime$3(resource.onsetDateTime),
      abatementDateTime: dateTime$3(resource.abatementDateTime),
      assertedDate: dateTime$3(resource.assertedDate),
      asserter: reference$1(resource.asserter),
      stage: stage.parse(resource.stage),
      evidence: map(resource.evidence, evidence.parse),
      note: map(resource.note, annotation$1)
    };
  }
  const zibProblem = {
    profile: profile$s,
    parse: parseZibProblem,
    uiSchema: uiSchema$s
  };
  const uiSchema$r = (resource, context) => {
    const ui = context.ui;
    const i18n = "zib_product";
    const productPackage = zibProductPackage.uiSchemaGroup(resource.package, context);
    const ingredients = map(
      resource.ingredient,
      (x) => zibProductIngredient.uiSchemaGroup(x, context),
      true
    );
    return {
      label: resource.description,
      children: [
        {
          label: `${i18n}.group_general_information`,
          children: [
            ui.codeableConcept(`${i18n}.code`, resource.code),
            ui.codeableConcept(`${i18n}.form`, resource.form)
          ]
        },
        {
          label: `${i18n}.group_ingredients`,
          children: ui.helpers.getChildren(ingredients)
        },
        productPackage
      ]
    };
  };
  const profile$r = "http://nictiz.nl/fhir/StructureDefinition/zib-Product";
  function parseZibProduct(resource) {
    return {
      ...resourceMeta(resource, profile$r, FhirVersion.R3),
      description: extensionNictiz(resource, "zib-Product-Description"),
      code: codeableConcept$1(resource.code),
      form: codeableConcept$1(resource.form),
      ingredient: map(resource.ingredient, zibProductIngredient.parse),
      package: zibProductPackage.parse(resource.package)
    };
  }
  const zibProduct = {
    profile: profile$r,
    parse: parseZibProduct,
    uiSchema: uiSchema$r
  };
  const uiSchemaGroup$h = (resource, context) => {
    const i18n = "zib_treatment_directive.actor";
    const ui = context.ui;
    return {
      label: i18n,
      children: [
        ui.codeableConcept(`${i18n}.role`, resource.role),
        ui.reference(`${i18n}.reference`, resource.reference)
      ]
    };
  };
  function parseActor$1(value2) {
    return {
      role: codeableConcept$1(value2?.role),
      reference: reference$1(value2?.reference)
    };
  }
  const actor$1 = {
    parse: parseActor$1,
    uiSchemaGroup: uiSchemaGroup$h
  };
  const uiSchemaGroup$g = (resource, context) => {
    const i18n = "zib_treatment_directive.data";
    const ui = context.ui;
    return {
      label: i18n,
      children: [
        ui.code(`${i18n}.meaning`, resource.meaning),
        ui.reference(`${i18n}.reference`, resource.reference)
      ]
    };
  };
  function parseData(value2) {
    return {
      meaning: code$1(value2?.meaning),
      reference: reference$1(value2?.reference)
    };
  }
  const data = {
    parse: parseData,
    uiSchemaGroup: uiSchemaGroup$g
  };
  const uiSchemaGroup$f = (resource, context) => {
    const i18n = "zib_treatment_directive.except";
    const ui = context.ui;
    const actor2 = map(resource.actor, (x) => uiSchemaGroup$h(x, context));
    const data2 = map(resource.data, (x) => uiSchemaGroup$g(x, context));
    return {
      label: i18n,
      children: [
        ui.code(`${i18n}.type`, resource.type),
        ...ui.period(`${i18n}.period`, resource.period),
        ui.codeableConcept(`${i18n}.action`, resource.action),
        ui.coding(`${i18n}.security_label`, resource.securityLabel),
        ui.coding(`${i18n}.purpose`, resource.purpose),
        ui.coding(`${i18n}.class`, resource.class),
        ui.coding(`${i18n}.code`, resource.code),
        ...ui.period(`${i18n}.plan`, resource.dataPeriod),
        ...ui.helpers.getChildren(actor2),
        ...ui.helpers.getChildren(data2)
      ]
    };
  };
  function parseExcept(value2) {
    return {
      type: code$1(value2?.type),
      period: period$1(value2?.period),
      actor: map(value2?.actor, actor$1.parse),
      action: map(value2?.action, codeableConcept$1),
      securityLabel: map(value2?.securityLabel, coding$1),
      purpose: map(value2?.purpose, coding$1),
      class: map(value2?.class, coding$1),
      code: map(value2?.code, coding$1),
      dataPeriod: period$1(value2?.dataPeriod),
      data: map(value2?.data, data.parse)
    };
  }
  const except = {
    parse: parseExcept,
    uiSchemaGroup: uiSchemaGroup$f
  };
  const uiSchemaGroup$e = (resource, context) => {
    const i18n = "zib_treatment_directive.policy";
    const ui = context.ui;
    return {
      label: i18n,
      children: [
        ui.string(`${i18n}.id`, resource.id),
        ui.string(`${i18n}.authority`, resource.authority),
        ui.string(`${i18n}.uri`, resource.uri)
      ]
    };
  };
  function parsePolicy(value2) {
    return {
      id: string$1(value2?.id),
      authority: string$1(value2?.authority),
      uri: string$1(value2?.uri)
    };
  }
  const policy = {
    parse: parsePolicy,
    uiSchemaGroup: uiSchemaGroup$e
  };
  const uiSchema$q = (resource, context) => {
    const ui = context.ui;
    const i18n = "zib_treatment_directive";
    const actor2 = map(resource.actor, (x) => uiSchemaGroup$h(x, context), true);
    const data2 = map(resource.data, (x) => uiSchemaGroup$g(x, context), true);
    const except2 = map(resource.except, (x) => uiSchemaGroup$f(x, context), true);
    const policy2 = map(resource.policy, (x) => uiSchemaGroup$e(x, context), true);
    return {
      label: resource.identifier?.value,
      children: [
        {
          label: `${i18n}.group_details`,
          children: [
            ui.identifier(`${i18n}.identifier`, resource.identifier),
            ui.code(`${i18n}.status`, resource.status),
            ui.codeableConcept(`${i18n}.category`, resource.category),
            ui.reference(`${i18n}.patient`, resource.patient),
            ...ui.period(`${i18n}.period`, resource.period),
            ui.dateTime(`${i18n}.date_time`, resource.dateTime),
            ui.reference(`${i18n}.consenting_party`, resource.consentingParty),
            ui.codeableConcept(`${i18n}.action`, resource.action),
            ui.reference(`${i18n}.organization`, resource.organization),
            ui.identifier(`${i18n}.source_identifier`, resource.sourceIdentifier),
            ui.reference(`${i18n}.source_reference`, resource.sourceReference),
            ui.string(`${i18n}.policy_rule`, resource.policyRule),
            ui.coding(`${i18n}.security_label`, resource.securityLabel),
            ui.coding(`${i18n}.purpose`, resource.purpose),
            ...ui.period(`${i18n}.data_period`, resource.dataPeriod)
          ]
        },
        uiSchemaGroup$o(resource.sourceAttachment, context),
        ...actor2,
        ...data2,
        ...except2,
        ...policy2
      ]
    };
  };
  const profile$q = "http://nictiz.nl/fhir/StructureDefinition/zib-TreatmentDirective";
  function parseZibTreatmentDirective(resource) {
    return {
      ...resourceMeta(resource, profile$q, FhirVersion.R3),
      identifier: identifier$1(resource.identifier),
      status: code$1(resource.status),
      category: map(resource.category, codeableConcept$1),
      patient: reference$1(resource.patient),
      period: period$1(resource.period),
      dateTime: dateTime$3(resource.dateTime),
      consentingParty: map(resource.consentingParty, reference$1),
      actor: map(resource.actor, actor$1.parse),
      action: map(resource.action, codeableConcept$1),
      organization: map(resource.organization, reference$1),
      sourceAttachment: attachment.parse(resource.sourceAttachment),
      sourceIdentifier: identifier$1(resource.sourceIdentifier),
      sourceReference: reference$1(resource.sourceReference),
      policy: map(resource.policy, policy.parse),
      policyRule: string$1(resource.policyRule),
      securityLabel: map(resource.securityLabel, coding$1),
      purpose: map(resource.purpose, coding$1),
      dataPeriod: period$1(resource.dataPeriod),
      data: map(resource.data, data.parse),
      except: map(resource.except, except.parse)
    };
  }
  const zibTreatmentDirective = {
    profile: profile$q,
    parse: parseZibTreatmentDirective,
    uiSchema: uiSchema$q
  };
  const uiSchema$p = (resource, context) => {
    const ui = context.ui;
    const i18n = "nl_core_observation";
    return {
      label: resource.identifier?.[0]?.value,
      children: [
        {
          label: `${i18n}.group_details`,
          children: [
            ui.identifier(`${i18n}.identifier`, resource.identifier),
            ui.code(`${i18n}.status`, resource.status),
            ui.codeableConcept(`${i18n}.category`, resource.category),
            ui.reference(`${i18n}.subject`, resource.subject),
            ui.reference(`${i18n}.context`, resource.context),
            Object.prototype.hasOwnProperty.call(resource, "effectiveDateTime") ? ui.dateTime(
              `${i18n}.effective_date_time`,
              resource.effectiveDateTime
            ) : void 0,
            ...ui.period(`${i18n}.effective_period`, resource.effectivePeriod),
            ui.codeableConcept(`${i18n}.data_absent_reason`, resource.dataAbsentReason),
            ui.string(`${i18n}.comment`, resource.comment),
            ui.codeableConcept(`${i18n}.body_site`, resource.bodySite)
          ].filter(isNonNullish)
        }
      ]
    };
  };
  const profile$p = "http://fhir.nl/fhir/StructureDefinition/nl-core-observation";
  function parseNlCoreObservationBase(resource) {
    return {
      identifier: map(resource.identifier, identifier$1),
      status: code$1(resource.status),
      category: map(resource.category, codeableConcept$1),
      subject: reference$1(resource.subject),
      context: reference$1(resource.context),
      valueQuantity: quantity$1(resource.valueQuantity),
      effectivePeriod: period$1(resource.effectivePeriod),
      dataAbsentReason: codeableConcept$1(resource.dataAbsentReason),
      method: codeableConcept$1(resource.method),
      bodySite: codeableConcept$1(resource.bodySite),
      effectiveDateTime: dateTime$3(resource.effectiveDateTime),
      comment: string$1(resource.comment)
    };
  }
  function parseNlCoreObservation(resource) {
    return {
      ...resourceMeta(resource, profile$p, FhirVersion.R3),
      ...parseNlCoreObservationBase(resource)
    };
  }
  const nlCoreObservation = {
    profile: profile$p,
    parse: parseNlCoreObservation,
    uiSchema: uiSchema$p
  };
  const uiSchema$o = (resource, context) => {
    return nlCoreObservation.uiSchema(resource, context);
  };
  const profile$o = "http://nictiz.nl/fhir/StructureDefinition/zib-LivingSituation";
  const parseZibLivingSituation = (resource) => {
    return {
      ...parseNlCoreObservationBase(resource),
      ...resourceMeta(resource, profile$o, FhirVersion.R3)
    };
  };
  const zibLivingSituation = {
    profile: profile$o,
    parse: parseZibLivingSituation,
    uiSchema: uiSchema$o
  };
  const uiSchema$n = (resource, context) => {
    return nlCoreObservation.uiSchema(resource, context);
  };
  const profile$n = "http://nictiz.nl/fhir/StructureDefinition/zib-AlcoholUse";
  function parseZibAlcoholUse(resource) {
    const { effectiveDateTime: _, ...rest } = parseNlCoreObservationBase(resource);
    return {
      ...rest,
      ...resourceMeta(resource, profile$n, FhirVersion.R3)
    };
  }
  const zibAlcoholUse = {
    profile: profile$n,
    parse: parseZibAlcoholUse,
    uiSchema: uiSchema$n
  };
  const uiSchema$m = (resource, context) => {
    return nlCoreObservation.uiSchema(resource, context);
  };
  const profile$m = "http://nictiz.nl/fhir/StructureDefinition/zib-DrugUse";
  function parseZibDrugUse(resource) {
    const { effectiveDateTime: _, ...rest } = parseNlCoreObservationBase(resource);
    return {
      ...rest,
      ...resourceMeta(resource, profile$m, FhirVersion.R3)
    };
  }
  const zibDrugUse = {
    profile: profile$m,
    parse: parseZibDrugUse,
    uiSchema: uiSchema$m
  };
  const uiSchema$l = (resource, context) => {
    return nlCoreObservation.uiSchema(resource, context);
  };
  const profile$l = "http://nictiz.nl/fhir/StructureDefinition/zib-FunctionalOrMentalStatus";
  function parseZibFunctionalOrMentalStatus(resource) {
    const { effectiveDateTime: _, ...rest } = parseNlCoreObservationBase(resource);
    return {
      ...rest,
      ...resourceMeta(resource, profile$l, FhirVersion.R3)
    };
  }
  const zibFunctionalOrMentalStatus = {
    profile: profile$l,
    parse: parseZibFunctionalOrMentalStatus,
    uiSchema: uiSchema$l
  };
  const uiSchema$k = (resource, context) => {
    return nlCoreObservation.uiSchema(resource, context);
  };
  const profile$k = "http://nictiz.nl/fhir/StructureDefinition/zib-TobaccoUse";
  function parseZibTobaccoUse(resource) {
    const { effectiveDateTime: _, ...rest } = parseNlCoreObservationBase(resource);
    return {
      ...rest,
      ...resourceMeta(resource, profile$k, FhirVersion.R3)
    };
  }
  const zibTobaccoUse = {
    profile: profile$k,
    parse: parseZibTobaccoUse,
    uiSchema: uiSchema$k
  };
  const uiSchema$j = (resource, context) => {
    const ui = context.ui;
    const i18n = "zib_nutrition_advice";
    return {
      label: resource.identifier?.at(0)?.value,
      children: [
        {
          label: `${i18n}.group_details`,
          children: [
            ui.string(`${i18n}.comment`, resource.comment),
            ui.identifier(`${i18n}.identifier`, resource.identifier),
            ui.code(`${i18n}.status`, resource.status),
            ui.reference(`${i18n}.patient`, resource.patient),
            ui.dateTime(`${i18n}.dateTime`, resource.dateTime),
            ui.codeableConcept(
              `${i18n}.food_preference_modifier`,
              resource.foodPreferenceModifier
            )
          ]
        }
      ]
    };
  };
  const profile$j = "http://nictiz.nl/fhir/StructureDefinition/zib-NutritionAdvice";
  function parseZibNutritionAdvice(resource) {
    return {
      ...resourceMeta(resource, profile$j, FhirVersion.R3),
      comment: extensionNictiz(resource, "zib-NutritionAdvice-Explanation"),
      identifier: map(resource.identifier, identifier$1),
      status: code$1(resource.status),
      patient: reference$1(resource.patient),
      dateTime: dateTime$3(resource.dateTime),
      foodPreferenceModifier: map(resource.foodPreferenceModifier, codeableConcept$1)
    };
  }
  const zibNutritionAdvice = {
    profile: profile$j,
    parse: parseZibNutritionAdvice,
    uiSchema: uiSchema$j
  };
  const uiSchema$i = (resource, context) => {
    const ui = context.ui;
    const i18n = "zib_medical_device_product";
    return {
      label: resource.id,
      children: [
        {
          label: `${i18n}.group_general_information`,
          children: [
            ui.reference(`${i18n}.patient`, resource.patient),
            ui.annotation(`${i18n}.note`, resource.note),
            ui.dateTime(`${i18n}.expiration_date`, resource.expirationDate)
          ]
        }
      ]
    };
  };
  const profile$i = "http://nictiz.nl/fhir/StructureDefinition/zib-MedicalDeviceProduct";
  function parseZibMedicalDeviceProduct(resource) {
    return {
      ...resourceMeta(resource, profile$i, FhirVersion.R3),
      note: map(resource.note, annotation$1),
      patient: reference$1(resource.patient),
      expirationDate: dateTime$3(resource.expirationDate)
    };
  }
  const zibMedicalDeviceProduct = {
    profile: profile$i,
    parse: parseZibMedicalDeviceProduct,
    uiSchema: uiSchema$i
  };
  const uiSchemaGroup$d = (resource, context) => {
    const ui = context.ui;
    return {
      label: "Immunization.practitioner.actor",
      children: [ui.reference(`Immunization.practitioner.actor`, resource.actor)]
    };
  };
  const uiSchema$h = (resource, context) => {
    const ui = context.ui;
    const practitioners = map(resource.practitioner, (x) => uiSchemaGroup$d(x, context), true);
    return {
      label: resource.vaccineCode?.coding?.[0]?.display ?? "",
      children: [
        {
          label: `Immunization`,
          children: [
            ui.codeableConcept("Immunization.vaccineCode", resource.vaccineCode),
            ui.quantity("Immunization.doseQuantity", resource.dose),
            ui.dateTime("Immunization.date", resource.vaccinationDate),
            ui.annotation(`Immunization.note.text`, resource.note),
            ...ui.helpers.getChildren(practitioners)
          ]
        }
      ]
    };
  };
  function parseActor(value2) {
    return {
      actor: reference$1(value2?.actor)
    };
  }
  const actor = {
    parse: parseActor,
    uiSchemaGroup: uiSchemaGroup$d
  };
  const profile$h = "http://nictiz.nl/fhir/StructureDefinition/zib-Vaccination";
  function parseZibVaccination(resource) {
    return {
      ...resourceMeta(resource, profile$h, FhirVersion.R3),
      identifier: map(resource.identifier, identifier$1),
      patient: reference$1(resource.patient),
      vaccineCode: codeableConcept$1(resource.vaccineCode),
      dose: quantity$1(resource.doseQuantity),
      vaccinationDate: date$4(resource.date),
      practitioner: map(resource.practitioner, actor.parse),
      note: map(resource.note, annotation$1)
    };
  }
  const zibVaccination = {
    profile: profile$h,
    parse: parseZibVaccination,
    uiSchema: uiSchema$h
  };
  const uiSchemaGroup$c = (resource, context) => {
    const ui = context.ui;
    return {
      label: "Encounter.diagnosis",
      children: [ui.reference(`Encounter.diagnosis.condition`, resource.condition)]
    };
  };
  function parseDiagnosis(value2) {
    return {
      condition: reference$1(value2?.condition),
      role: codeableConcept$1(value2?.role),
      rank: positiveInt$1(value2?.rank)
    };
  }
  const diagnosis = {
    parse: parseDiagnosis,
    uiSchemaGroup: uiSchemaGroup$c
  };
  const uiSchemaGroup$b = (resource, context) => {
    const ui = context.ui;
    return {
      label: "Encounter.hospitalization",
      children: [
        ui.codeableConcept(`Encounter.hospitalization.admitSource`, resource.admitSource),
        ui.codeableConcept(
          `Encounter.hospitalization.dischargeDisposition`,
          resource.dischargeDisposition
        )
      ]
    };
  };
  function parseHospitalization(value2) {
    return {
      admitSource: codeableConcept$1(value2?.admitSource),
      dischargeDisposition: codeableConcept$1(value2?.dischargeDisposition)
    };
  }
  const hospitalization = {
    parse: parseHospitalization,
    uiSchemaGroup: uiSchemaGroup$b
  };
  const uiSchema$g = (resource, context) => {
    const ui = context.ui;
    const profile2 = "Encounter";
    const diagnosis2 = map(resource.diagnosis, (x) => uiSchemaGroup$c(x, context), true);
    const participants = map(
      resource.participant,
      (x) => uiSchemaGroup$x(x, context),
      true
    );
    return {
      label: resource.serviceProvider?.display,
      children: [
        {
          label: `${profile2}`,
          children: [
            ui.coding(`${profile2}.class`, resource.class),
            ...ui.helpers.getChildren(participants),
            ui.reference(`${profile2}.serviceProvider`, resource.serviceProvider),
            ...ui.period(`${profile2}.period`, resource.period),
            ...ui.helpers.getChildren(diagnosis2),
            ui.codeableConcept(`${profile2}.reason`, resource.reason),
            ...ui.helpers.getChildren(
              uiSchemaGroup$b(resource.hospitalization, context)
            )
          ]
        }
      ]
    };
  };
  const profile$g = "http://nictiz.nl/fhir/StructureDefinition/zib-Encounter";
  function parseZibEncounter(resource) {
    return {
      ...resourceMeta(resource, profile$g, FhirVersion.R3),
      class: coding$1(resource.class),
      participant: map(resource.participant, encounterParticipant.parse),
      serviceProvider: reference$1(resource.serviceProvider),
      period: period$1(resource.period),
      diagnosis: map(resource.diagnosis, diagnosis.parse),
      reason: map(resource.reason, codeableConcept$1),
      hospitalization: hospitalization.parse(resource.hospitalization)
    };
  }
  const zibEncounter = {
    profile: profile$g,
    parse: parseZibEncounter,
    uiSchema: uiSchema$g
  };
  const uiSchema$f = (resource, context) => {
    const ui = context.ui;
    const profile2 = "zib_blood_pressure";
    return {
      label: resource.effectiveDateTime,
      children: [
        {
          label: `${profile2}`,
          children: [
            ui.codeableConcept(`${profile2}.method`, resource.method),
            ui.codeableConcept(
              `${profile2}.cuff_type_loinc`,
              resource.cuffTypeLOINC.valueCodeableConcept
            ),
            ui.codeableConcept(
              `${profile2}.cuff_type_snomed`,
              resource.cuffTypeSNOMED.valueCodeableConcept
            ),
            ui.codeableConcept(`${profile2}.bodySite`, resource.bodySite),
            ui.codeableConcept(
              `${profile2}.diastolic_endpoint`,
              resource.diastolicEndpoint.valueCodeableConcept
            ),
            ui.quantity(`${profile2}.systolic_bp`, resource.systolicBP.valueQuantity),
            ui.quantity(`${profile2}.diastolic_bp.code`, resource.diastolicBP.valueQuantity),
            ui.quantity(
              `${profile2}.average_blood_pressure_loinc`,
              resource.averageBloodPressureLOINC.valueQuantity
            ),
            ui.quantity(
              `${profile2}.average_blood_pressure_snomed`,
              resource.averageBloodPressureSNOMED.valueQuantity
            ),
            ui.dateTime(`${profile2}.effective`, resource.effectiveDateTime),
            ui.string(`${profile2}.comment`, resource.comment),
            ui.codeableConcept(
              `${profile2}.position_snomed`,
              resource.positionSNOMED.valueCodeableConcept
            ),
            ui.codeableConcept(
              `${profile2}.position_loinc`,
              resource.positionLOINC.valueCodeableConcept
            )
          ]
        }
      ]
    };
  };
  const profile$f = "http://nictiz.nl/fhir/StructureDefinition/zib-BloodPressure";
  function parseZibBloodPressure(resource) {
    const cuffTypeLOINC = findComponentByCode(resource.component, "8358-4");
    const cuffTypeSNOMED = findComponentByCode(resource.component, "70665002");
    const diastolicEndpoint = findComponentByCode(resource.component, "85549003");
    const systolicBP = findComponentByCode(resource.component, "8480-6");
    const diastolicBP = findComponentByCode(resource.component, "8462-4");
    const averageBloodPressureLOINC = findComponentByCode(resource.component, "8478-0");
    const averageBloodPressureSNOMED = findComponentByCode(resource.component, "6797001");
    const positionSNOMED = findComponentByCode(resource.component, "424724000");
    const positionLOINC = findComponentByCode(resource.component, "8361-8");
    return {
      ...parseNlCoreObservationBase(resource),
      ...resourceMeta(resource, profile$f, FhirVersion.R3),
      cuffTypeLOINC: {
        valueCodeableConcept: codeableConcept$1(cuffTypeLOINC?.valueCodeableConcept)
      },
      cuffTypeSNOMED: {
        valueCodeableConcept: codeableConcept$1(cuffTypeSNOMED?.valueCodeableConcept)
      },
      diastolicEndpoint: {
        valueCodeableConcept: codeableConcept$1(diastolicEndpoint?.valueCodeableConcept)
      },
      systolicBP: {
        valueQuantity: quantity$1(systolicBP?.valueQuantity)
      },
      diastolicBP: {
        valueQuantity: quantity$1(diastolicBP?.valueQuantity)
      },
      averageBloodPressureLOINC: {
        valueQuantity: quantity$1(averageBloodPressureLOINC?.valueQuantity)
      },
      averageBloodPressureSNOMED: {
        valueQuantity: quantity$1(averageBloodPressureSNOMED?.valueQuantity)
      },
      positionSNOMED: {
        valueCodeableConcept: codeableConcept$1(positionSNOMED?.valueCodeableConcept)
      },
      positionLOINC: {
        valueCodeableConcept: codeableConcept$1(positionLOINC?.valueCodeableConcept)
      }
    };
  }
  const zibBloodPressure = {
    profile: profile$f,
    parse: parseZibBloodPressure,
    uiSchema: uiSchema$f
  };
  const uiSchema$e = (resource, context) => {
    const ui = context.ui;
    const profile2 = "zib_body_weight";
    return {
      label: resource.effectiveDateTime,
      children: [
        {
          label: `${profile2}`,
          children: [
            ui.quantity(profile2, resource.valueQuantity),
            ui.string(`${profile2}.comment`, resource.comment),
            ui.dateTime(`${profile2}.effective`, resource.effectiveDateTime),
            ui.codeableConcept(
              `${profile2}.clothing`,
              resource.clothing.valueCodeableConcept
            )
          ]
        }
      ]
    };
  };
  const profile$e = "http://nictiz.nl/fhir/StructureDefinition/zib-BodyWeight";
  function parseZibBodyWeight(resource) {
    const clothing = findComponentByCode(resource.component, "8352-7");
    return {
      ...parseNlCoreObservationBase(resource),
      ...resourceMeta(resource, profile$e, FhirVersion.R3),
      clothing: {
        valueCodeableConcept: codeableConcept$1(clothing?.valueCodeableConcept)
      }
    };
  }
  const zibBodyWeight = {
    profile: profile$e,
    parse: parseZibBodyWeight,
    uiSchema: uiSchema$e
  };
  const uiSchema$d = (resource, context) => {
    const ui = context.ui;
    const profile2 = "zib_body_height";
    return {
      label: resource.effectiveDateTime,
      children: [
        {
          label: `${profile2}`,
          children: [
            ui.quantity(profile2, resource.valueQuantity),
            ui.dateTime(`${profile2}.effective`, resource.effectiveDateTime),
            ui.string(`${profile2}.comment`, resource.comment)
          ]
        }
      ]
    };
  };
  const profile$d = "http://nictiz.nl/fhir/StructureDefinition/zib-BodyHeight";
  function parseZibBodyHeight(resource) {
    return {
      ...parseNlCoreObservationBase(resource),
      ...resourceMeta(resource, profile$d, FhirVersion.R3)
    };
  }
  const zibBodyHeight = {
    profile: profile$d,
    parse: parseZibBodyHeight,
    uiSchema: uiSchema$d
  };
  const uiSchemaGroup$a = (resource, context) => {
    const ui = context.ui;
    return {
      label: "zib_procedure.focal_device",
      children: [ui.reference(`zib_procedure.focal_device.manipulated`, resource.manipulated)]
    };
  };
  function parseFocalDevice(value2) {
    return {
      manipulated: reference$1(value2?.manipulated)
    };
  }
  const focalDevice = {
    parse: parseFocalDevice,
    uiSchemaGroup: uiSchemaGroup$a
  };
  const uiSchemaGroup$9 = (resource, context) => {
    const ui = context.ui;
    return {
      label: "zib_procedure.performer",
      children: [ui.reference(`zib_procedure.performer`, resource.actor)]
    };
  };
  function parsePerformer(value2) {
    return {
      actor: reference$1(value2?.actor)
    };
  }
  const performer = {
    parse: parsePerformer,
    uiSchemaGroup: uiSchemaGroup$9
  };
  const uiSchema$c = (resource, context) => {
    const ui = context.ui;
    const profile2 = "zib_procedure";
    const focalDevices = map(resource.focalDevice, (x) => uiSchemaGroup$a(x, context), true);
    const performers = map(resource.performer, (x) => uiSchemaGroup$9(x, context), true);
    return {
      label: resource.code?.coding?.at(0)?.display,
      children: [
        {
          label: `${profile2}`,
          children: [
            ...ui.period(`${profile2}.performed_period`, resource.performedPeriod),
            ui.codeableConcept(`${profile2}.body_site`, resource.bodySite),
            ui.codeableConcept(
              `${profile2}.bodySite.extension:ProcedureLaterality`,
              resource.bodySiteQualifier
            ),
            ui.reference(`${profile2}.reason_reference`, resource.reasonReference),
            ui.codeableConcept(`${profile2}.code`, resource.code),
            ui.codeableConcept(`${profile2}.procedure_method`, resource.procedureMethod),
            ...ui.helpers.getChildren(focalDevices),
            ui.reference(`${profile2}.location`, resource.location),
            ...ui.helpers.getChildren(performers),
            ui.reference(`${profile2}.subject`, resource.subject)
          ]
        }
      ]
    };
  };
  const profile$c = "http://nictiz.nl/fhir/StructureDefinition/zib-Procedure";
  function parseZibProcedure(resource) {
    return {
      ...resourceMeta(resource, profile$c, FhirVersion.R3),
      performedPeriod: period$1(resource.performedPeriod),
      bodySite: map(resource.bodySite, codeableConcept$1),
      bodySiteQualifier: resource.bodySite?.map((x) => extensionNictiz(x, "BodySite-Qualifier")).filter(isNonNullish),
      reasonReference: map(resource.reasonReference, reference$1),
      code: codeableConcept$1(resource.code),
      procedureMethod: extension(
        resource,
        "http://hl7.org/fhir/StructureDefinition/procedure-method",
        // NOSONAR
        "codeableConcept"
      ),
      focalDevice: map(resource.focalDevice, focalDevice.parse),
      location: reference$1(resource.location),
      performer: map(resource.performer, performer.parse),
      subject: reference$1(resource.subject)
    };
  }
  const zibProcedure = {
    profile: profile$c,
    parse: parseZibProcedure,
    uiSchema: uiSchema$c
  };
  const uiSchemaGroup$8 = (resource, context) => {
    const ui = context.ui;
    const i18n = "zib_laboratory_test_result_specimen.container";
    return {
      label: `${i18n}`,
      children: [
        ui.identifier(`${i18n}.identifier`, resource.identifier),
        ui.codeableConcept(`${i18n}.type`, resource.type)
      ]
    };
  };
  const uiSchema$b = (resource, context) => {
    const ui = context.ui;
    const profile2 = "zib_laboratory_test_result_specimen";
    const container2 = map(resource.container, (x) => uiSchemaGroup$8(x, context), true);
    return {
      label: resource.type?.coding?.[0]?.display ?? `${profile2}`,
      children: [
        {
          label: `${profile2}`,
          children: [
            ui.identifier(`${profile2}.identifier`, resource.identifier),
            ...ui.helpers.getChildren(container2),
            ui.codeableConcept(`${profile2}.type`, resource.type),
            ui.quantity(`${profile2}.quantity`, resource.collection.quantity),
            ...ui.oneOfValueX(`${profile2}.collected`, resource.collection, "collected"),
            ui.dateTime(`${profile2}.received_time`, resource.receivedTime),
            ui.codeableConcept(`${profile2}.collection.method`, resource.collection.method),
            ui.codeableConcept(`${profile2}.body_site`, resource.collection.bodySite.value),
            ui.codeableConcept(
              `${profile2}.body_site.laterality`,
              resource.collection.bodySite.laterality
            ),
            ui.codeableConcept(
              `${profile2}.body_site.morphology`,
              resource.collection.bodySite.morphology
            ),
            ui.reference(`${profile2}.subject`, resource.subject),
            ui.annotation(`${profile2}.note`, resource.note)
          ]
        }
      ]
    };
  };
  function parseContainer$1(value2) {
    return {
      identifier: map(value2?.identifier, identifier$1),
      type: codeableConcept$1(value2?.type)
    };
  }
  const container$1 = {
    parse: parseContainer$1,
    uiSchemaGroup: uiSchemaGroup$8
  };
  const profile$b = "http://nictiz.nl/fhir/StructureDefinition/zib-LaboratoryTestResult-Specimen";
  function parseZibLaboratoryTestResultSpecimen(resource) {
    const collection = resource.collection;
    return {
      ...resourceMeta(resource, profile$b, FhirVersion.R3),
      identifier: map(resource.identifier, identifier$1),
      // NL-CM:13.1.15
      subject: reference$1(resource.subject),
      // NL-CM:13.1.29
      container: map(resource.container, container$1.parse),
      // NL-CM:13.1.20 & NL-CM:13.1.21
      type: codeableConcept$1(resource.type),
      // NL-CM:13.1.16
      receivedTime: dateTime$3(resource.receivedTime),
      // NL-CM:13.1.25
      collection: {
        quantity: quantity$1(collection?.quantity),
        // NL-CM:13.1.23
        ...oneOfValueX$1(collection, ["dateTime", "period"], "collected"),
        // dateTime NL-CM:13.1.17, period NL-CM:13.1.24
        method: codeableConcept$1(collection?.method),
        // NL-CM:13.1.18
        bodySite: {
          value: codeableConcept$1(collection?.bodySite),
          // NL-CM:13.1.26
          laterality: extensionNictiz(collection?.bodySite, "BodySite-Qualifier"),
          // NL-CM:13.1.27
          morphology: extensionNictiz(collection?.bodySite, "BodySite-Morphology")
          // NL-CM:13.1.28
        }
      },
      note: map(resource.note, annotation$1)
      // NL-CM:13.1.19
    };
  }
  const zibLaboratoryTestResultSpecimen = {
    profile: profile$b,
    parse: parseZibLaboratoryTestResultSpecimen,
    uiSchema: uiSchema$b
  };
  const uiSchemaGroup$7 = (resource, context) => {
    const ui = context.ui;
    const i18n = "zib_laboratory_test_result_specimen_isolate.container";
    return {
      label: `${i18n}`,
      children: [
        ui.identifier(`${i18n}.identifier`, resource.identifier),
        ui.codeableConcept(`${i18n}.type`, resource.type)
      ]
    };
  };
  const uiSchema$a = (resource, context) => {
    const ui = context.ui;
    const profile2 = "zib_laboratory_test_result_specimen_isolate";
    const container2 = map(resource.container, (x) => uiSchemaGroup$7(x, context), true);
    return {
      label: resource.type?.coding?.[0]?.display ?? `${profile2}`,
      children: [
        {
          label: `${profile2}`,
          children: [
            ui.identifier(`${profile2}.identifier`, resource.identifier),
            ...ui.helpers.getChildren(container2),
            ui.codeableConcept(`${profile2}.type`, resource.type),
            ui.quantity(`${profile2}.quantity`, resource.collection.quantity),
            ...ui.oneOfValueX(`${profile2}.collected`, resource.collection, "collected"),
            ui.dateTime(`${profile2}.received_time`, resource.receivedTime),
            ui.codeableConcept(`${profile2}.collection.method`, resource.collection.method),
            ui.codeableConcept(`${profile2}.body_site`, resource.collection.bodySite.value),
            ui.codeableConcept(
              `${profile2}.body_site.laterality`,
              resource.collection.bodySite.laterality
            ),
            ui.codeableConcept(
              `${profile2}.body_site.morphology`,
              resource.collection.bodySite.morphology
            ),
            ui.reference(`${profile2}.subject`, resource.subject),
            ui.annotation(`${profile2}.note`, resource.note)
          ]
        }
      ]
    };
  };
  function parseContainer(value2) {
    return {
      identifier: map(value2?.identifier, identifier$1),
      type: codeableConcept$1(value2?.type)
    };
  }
  const container = {
    parse: parseContainer,
    uiSchemaGroup: uiSchemaGroup$7
  };
  const profile$a = "http://nictiz.nl/fhir/StructureDefinition/zib-LaboratoryTestResult-Specimen-Isolate";
  function parseZibLaboratoryTestResultSpecimenIsolate(resource) {
    const collection = resource.collection;
    return {
      ...resourceMeta(resource, profile$a, FhirVersion.R3),
      identifier: map(resource.identifier, identifier$1),
      // NL-CM:13.1.15
      subject: reference$1(resource.subject),
      // NL-CM:13.1.29
      container: map(resource.container, container.parse),
      // NL-CM:13.1.20 & NL-CM:13.1.21
      type: codeableConcept$1(resource.type),
      // NL-CM:13.1.22
      receivedTime: dateTime$3(resource.receivedTime),
      // NL-CM:13.1.25
      collection: {
        quantity: quantity$1(collection?.quantity),
        // NL-CM:13.1.23
        ...oneOfValueX$1(collection, ["dateTime", "period"], "collected"),
        // dateTime NL-CM:13.1.17, period NL-CM:13.1.24
        method: codeableConcept$1(collection?.method),
        // NL-CM:13.1.18
        bodySite: {
          value: codeableConcept$1(collection?.bodySite),
          // NL-CM:13.1.26
          laterality: extensionNictiz(collection?.bodySite, "BodySite-Qualifier"),
          // NL-CM:13.1.27
          morphology: extensionNictiz(collection?.bodySite, "BodySite-Morphology")
          // NL-CM:13.1.28
        }
      },
      note: map(resource.note, annotation$1)
      // NL-CM:13.1.19
    };
  }
  const zibLaboratoryTestResultSpecimenIsolate = {
    profile: profile$a,
    parse: parseZibLaboratoryTestResultSpecimenIsolate,
    uiSchema: uiSchema$a
  };
  const uiSchema$9 = (resource, context) => {
    const ui = context.ui;
    const i18n = "zib_laboratory_test_result_substance";
    return {
      label: `${i18n}`,
      children: [
        {
          label: `${i18n}`,
          children: [ui.codeableConcept(`${i18n}.code`, resource.code)]
        }
      ]
    };
  };
  const profile$9 = "http://nictiz.nl/fhir/StructureDefinition/zib-LaboratoryTestResult-Substance";
  function parseZibLaboratoryTestResultSubstance(resource) {
    return {
      ...resourceMeta(resource, profile$9, FhirVersion.R3),
      identifier: map(resource.identifier, identifier$1),
      status: string$1(resource?.status),
      category: map(resource.category, codeableConcept$1),
      code: codeableConcept$1(resource.code),
      // NL-CM:13.1.22
      description: string$1(resource.description)
    };
  }
  const zibLaboratoryTestResultSubstance = {
    profile: profile$9,
    parse: parseZibLaboratoryTestResultSubstance,
    uiSchema: uiSchema$9
  };
  const uiSchema$8 = (resource, context) => {
    const ui = context.ui;
    const profile2 = "zib_advance_directive";
    const attachment2 = uiSchemaGroup$o(resource.source.attachment, context);
    return {
      label: resource.dateTime,
      children: [
        {
          label: `${profile2}.group_details`,
          children: [
            ui.codeableConcept(`${profile2}.type_of_living_will`, resource.category),
            ui.dateTime(`${profile2}.date_time`, resource.dateTime),
            ui.reference(`${profile2}.disorder`, resource.disorder),
            ui.reference(`${profile2}.consenting_party`, resource.consentingParty),
            ui.string(`${profile2}.comment`, resource.comment)
          ]
        },
        attachment2
      ]
    };
  };
  const profile$8 = "http://nictiz.nl/fhir/StructureDefinition/zib-AdvanceDirective";
  function parseZibAdvanceDirective(resource) {
    return {
      ...resourceMeta(resource, profile$8, FhirVersion.R3),
      category: map(resource.category, codeableConcept$1),
      dateTime: dateTime$3(resource.dateTime),
      disorder: extensionNictiz(resource, "zib-AdvanceDirective-Disorder"),
      consentingParty: map(resource.consentingParty, reference$1),
      source: {
        attachment: attachment.parse(resource.sourceAttachment),
        identifier: identifier$1(resource.sourceIdentifier),
        reference: reference$1(resource.sourceReference)
      },
      comment: extensionNictiz(resource, "Comment")
    };
  }
  const zibAdvanceDirective = {
    profile: profile$8,
    parse: parseZibAdvanceDirective,
    uiSchema: uiSchema$8
  };
  const uiSchema$7 = (resource, context) => {
    const ui = context.ui;
    const profile2 = "zib_procedure_request";
    return {
      label: resource.code?.coding?.at(0)?.display,
      children: [
        {
          label: `${profile2}`,
          children: [
            ui.string(`${profile2}.status.order_status`, resource.status),
            ...ui.period(`${profile2}.occurrence_period`, resource.occurrence),
            ui.codeableConcept(`${profile2}.code`, resource.code),
            ui.reference(`${profile2}.perfomer`, resource.perfomer)
          ]
        }
      ]
    };
  };
  const profile$7 = "http://nictiz.nl/fhir/StructureDefinition/zib-ProcedureRequest";
  function parseZibProcedureRequest(resource) {
    return {
      ...resourceMeta(resource, profile$7, FhirVersion.R3),
      status: string$1(resource.status),
      occurrence: period$1(resource.occurrencePeriod),
      code: codeableConcept$1(resource.code),
      intent: string$1(resource.intent),
      subject: reference$1(resource.subject),
      perfomer: reference$1(resource.performer),
      reason: map(resource.reasonReference, reference$1)
    };
  }
  const zibProcedureRequest = {
    profile: profile$7,
    parse: parseZibProcedureRequest,
    uiSchema: uiSchema$7
  };
  const uiSchema$6 = (resource, context) => {
    const ui = context.ui;
    const profile2 = "zib_medical_device_request";
    return {
      label: resource.occurrence?.start,
      children: [
        {
          label: `${profile2}`,
          children: [
            ui.string(`${profile2}.status.order_status`, resource.status),
            ...ui.period(`${profile2}.occurrence_period`, resource.occurrence),
            ...ui.oneOfValueX(`${profile2}.code`, resource, "code"),
            ui.reference(`${profile2}.perfomer`, resource.perfomer)
          ]
        }
      ]
    };
  };
  const profile$6 = "http://nictiz.nl/fhir/StructureDefinition/zib-MedicalDeviceRequest";
  function parseZibMedicalDeviceRequest(resource) {
    return {
      ...resourceMeta(resource, profile$6, FhirVersion.R3),
      status: string$1(resource.status),
      occurrence: period$1(resource.occurrencePeriod),
      ...oneOfValueX$1(resource, ["reference", "codeableConcept"], "code"),
      intent: codeableConcept$1(resource.intent),
      subject: reference$1(resource.subject),
      perfomer: reference$1(resource.performer)
    };
  }
  const zibMedicalDeviceRequest = {
    profile: profile$6,
    parse: parseZibMedicalDeviceRequest,
    uiSchema: uiSchema$6
  };
  const uiSchemaGroup$6 = (resource, context) => {
    const profile2 = "zib_vaccination_recommendation.recommendation";
    const ui = context.ui;
    return {
      label: profile2,
      children: [
        ui.dateTime(`${profile2}.date`, resource.date),
        ui.codeableConcept(`${profile2}.vaccine_code`, resource.code),
        ui.dateTime(`${profile2}.date_criterion`, resource.dateCriterion)
      ]
    };
  };
  function parseRecommendation(value2) {
    return {
      date: dateTime$3(value2?.date),
      code: codeableConcept$1(value2?.vaccineCode),
      dateCriterion: map(value2?.dateCriterion, (x) => dateTime$3(x.value))
    };
  }
  const recommendation = {
    parse: parseRecommendation,
    uiSchemaGroup: uiSchemaGroup$6
  };
  const uiSchema$5 = (resource, context) => {
    const ui = context.ui;
    const profile2 = "zib_vaccination_recommendation";
    const recommendation2 = map(
      resource.recommendation,
      (x) => uiSchemaGroup$6(x, context),
      true
    );
    return {
      label: resource.recommendation?.at(0)?.code?.coding?.at(0)?.display,
      children: [
        {
          label: `${profile2}`,
          children: [
            ui.codeableConcept(`${profile2}.order_status`, resource.orderStatus),
            ...ui.helpers.getChildren(recommendation2)
          ]
        }
      ]
    };
  };
  const profile$5 = "http://nictiz.nl/fhir/StructureDefinition/zib-VaccinationRecommendation";
  function parseZibVaccinationRecommendation(resource) {
    return {
      ...resourceMeta(resource, profile$5, FhirVersion.R3),
      orderStatus: extensionNictiz(resource, "zib-VaccinationRecommendation-OrderStatus"),
      recommendation: map(resource.recommendation, recommendation.parse)
    };
  }
  const zibVaccinationRecommendation = {
    profile: profile$5,
    parse: parseZibVaccinationRecommendation,
    uiSchema: uiSchema$5
  };
  const uiSchema$4 = (resource, context) => {
    const ui = context.ui;
    const profile2 = "e_afspraak_appointment";
    return {
      label: resource.description,
      children: [
        {
          label: `${profile2}`,
          children: [
            ui.string(`${profile2}.status.order_status`, resource.status),
            ui.codeableConcept(`${profile2}.specialty`, resource.specialty),
            ui.string(`${profile2}.description`, resource.description),
            ui.dateTime(`${profile2}.start`, resource.start),
            ui.dateTime(`${profile2}.end`, resource.end),
            ui.reference(
              `${profile2}.participant`,
              resource.participant?.flatMap((x) => x.actor).filter(isNonNullish)
            )
          ]
        }
      ]
    };
  };
  const profile$4 = "http://nictiz.nl/fhir/StructureDefinition/eAfspraak-Appointment";
  function parseEAfspraakAppointment(resource) {
    return {
      ...resourceMeta(resource, profile$4, FhirVersion.R3),
      status: string$1(resource.status),
      specialty: map(resource.specialty, codeableConcept$1),
      description: string$1(resource.description),
      start: dateTime$3(resource.start),
      end: dateTime$3(resource.end),
      participant: map(resource.participant, (x) => ({ actor: reference$1(x.actor) }))
    };
  }
  const eAfspraakAppointment = {
    profile: profile$4,
    parse: parseEAfspraakAppointment,
    uiSchema: uiSchema$4
  };
  function parseContent(value2) {
    return {
      attachment: value2?.attachment ? attachment.parse(value2.attachment) : void 0
    };
  }
  const uiSchema$3 = (resource, context) => {
    const ui = context.ui;
    const i18n = "ihe_mhd_minimal_document_reference";
    const generalInformation = {
      MasterIdentifier: ui.identifier(`${i18n}.master_identifier`, resource.masterIdentifier),
      Status: ui.code(`${i18n}.status`, resource.status),
      Type: ui.codeableConcept(`${i18n}.type`, resource.type),
      Class: ui.codeableConcept(`${i18n}.class`, resource.class),
      Subject: ui.reference(`${i18n}.subject`, resource.subject),
      Indexed: ui.string(`${i18n}.indexed`, resource.indexed),
      Created: ui.string(`${i18n}.created`, resource.created),
      Author: map(resource.author, (x) => ui.reference(`${i18n}.author`, x), true),
      SecurityLabel: ui.codeableConcept(`${i18n}.security_label`, resource.securityLabel)
    };
    const content = {
      Title: ui.string(`${i18n}.content.attachment.title`, resource.content.attachment?.title),
      ContentType: ui.string(
        `${i18n}.content.attachment.content_type`,
        resource.content.attachment?.contentType
      ),
      Language: ui.string(
        `${i18n}.content.attachment.language`,
        resource.content.attachment?.language
      ),
      Location: resource.content.attachment ? ui.downloadLink(resource.content.attachment) : null,
      Url: ui.string(`${i18n}.content.attachment.url`, resource.content.attachment?.url),
      Creation: ui.dateTime(
        `${i18n}.content.attachment.date_time`,
        resource.content.attachment?.creation
      )
    };
    return {
      label: content.Title.display ?? context.formatMessage("fhir.unknown"),
      children: [
        {
          label: `${i18n}.group_general_information`,
          children: [
            generalInformation.Indexed,
            generalInformation.Created,
            ...generalInformation.Author,
            generalInformation.Subject,
            generalInformation.MasterIdentifier,
            generalInformation.Status,
            generalInformation.SecurityLabel,
            content.ContentType,
            content.Language,
            generalInformation.Type
          ]
        },
        {
          label: `${i18n}.document`,
          children: [content.Url, content.Creation, content.Location].filter(isNonNullish)
        }
      ]
    };
  };
  const profile$3 = "http://nictiz.nl/fhir/StructureDefinition/IHE.MHD.Minimal.DocumentReference";
  function parseIheMhdMinimalDocumentReference(resource) {
    return {
      ...resourceMeta(resource, profile$3, FhirVersion.R3),
      masterIdentifier: identifier$1(resource.masterIdentifier),
      status: code$1(resource.status),
      type: codeableConcept$1(resource.type),
      class: codeableConcept$1(resource.class),
      subject: reference$1(resource.subject),
      indexed: string$1(resource.indexed),
      created: string$1(resource.created),
      author: map(resource.author, reference$1),
      content: parseContent(resource.content[0]),
      securityLabel: map(resource.securityLabel, codeableConcept$1)
    };
  }
  const iheMhdMinimalDocumentReference = {
    profile: profile$3,
    parse: parseIheMhdMinimalDocumentReference,
    uiSchema: uiSchema$3
  };
  const resourcesR3 = /* @__PURE__ */ Object.freeze(/* @__PURE__ */ Object.defineProperty({
    __proto__: null,
    eAfspraakAppointment,
    gpDiagnosticResult,
    gpEncounter,
    gpEncounterReport,
    gpJournalEntry,
    gpLaboratoryResult,
    iheMhdMinimalDocumentReference,
    nlCoreObservation,
    nlCoreOrganization,
    nlCorePatient,
    nlCorePractitioner,
    nlCorePractitionerRole,
    zibAdministrationAgreement,
    zibAdvanceDirective,
    zibAlcoholUse,
    zibAlert,
    zibAllergyIntolerance,
    zibBloodPressure,
    zibBodyHeight,
    zibBodyWeight,
    zibDrugUse,
    zibEncounter,
    zibFunctionalOrMentalStatus,
    zibLaboratoryTestResultObservation,
    zibLaboratoryTestResultSpecimen,
    zibLaboratoryTestResultSpecimenIsolate,
    zibLaboratoryTestResultSubstance,
    zibLivingSituation,
    zibMedicalDevice,
    zibMedicalDeviceProduct,
    zibMedicalDeviceRequest,
    zibMedicationAgreement,
    zibMedicationUse,
    zibNutritionAdvice,
    zibPayer,
    zibProblem,
    zibProcedure,
    zibProcedureRequest,
    zibProduct,
    zibTobaccoUse,
    zibTreatmentDirective,
    zibVaccination,
    zibVaccinationRecommendation
  }, Symbol.toStringTag, { value: "Module" }));
  const uiSchemaGroup$5 = (resource, context) => {
    const ui = context.ui;
    if (resource?.use === "usual") {
      const i18n2 = "nl_name_information_given_name";
      return {
        label: i18n2,
        children: [ui.string(`${i18n2}.given`, resource.given)]
      };
    }
    const i18n = "nl_name_information";
    return {
      label: i18n,
      children: [
        ui.string(`${i18n}.text`, resource?.text),
        ui.string(`${i18n}.family`, resource?.family),
        ui.string(`${i18n}.given`, resource?.given),
        ui.string(`${i18n}.name_usage`, resource?.nameUsage),
        ui.string(`${i18n}.prefix`, resource?.prefix),
        ui.string(`${i18n}.suffix`, resource?.suffix)
      ]
    };
  };
  function parseNlCoreNameInformation(value2) {
    if (value2?.use === "usual") {
      return {
        use: value2.use,
        given: map(value2?.given, string$1),
        period: period$1(value2?.period),
        text: string$1(value2?.text)
      };
    }
    const nameValues = filterPrimitiveByExtension(value2, "given", {
      url: "http://hl7.org/fhir/StructureDefinition/iso21090-EN-qualifier",
      // NOSONAR
      valueCode: "BR"
    });
    const initialValues = filterPrimitiveByExtension(value2, "given", {
      url: "http://hl7.org/fhir/StructureDefinition/iso21090-EN-qualifier",
      // NOSONAR
      valueCode: "IN"
    });
    return {
      nameUsage: extension(
        value2,
        "http://hl7.org/fhir/StructureDefinition/humanname-assembly-order",
        // NOSONAR
        "code"
      ),
      family: string$1(value2?.family),
      given: map(value2?.given, string$1),
      givenNames: map(nameValues, string$1),
      givenInitials: map(initialValues, string$1),
      period: period$1(value2?.period),
      prefix: map(value2?.prefix, string$1),
      suffix: map(value2?.suffix, string$1),
      text: string$1(value2?.text),
      use: string$1(value2?.use)
    };
  }
  const nlCoreNameInformation = {
    parse: parseNlCoreNameInformation,
    uiSchemaGroup: uiSchemaGroup$5
  };
  const uiSchemaGroup$4 = (resource, context) => {
    const i18n = "nl_core_address_information";
    const ui = context.ui;
    return {
      label: i18n,
      children: [
        ui.string(`${i18n}.streetName`, resource?.streetName),
        ui.string(`${i18n}.houseNumber`, resource?.houseNumber),
        ui.string(`${i18n}.houseNumberAddition`, resource?.houseNumberAddition),
        ui.string(`${i18n}.houseNumberIndication`, resource?.houseNumberIndication),
        ui.string(`${i18n}.additionalInformation`, resource?.additionalInformation),
        ui.string(`${i18n}.city`, resource?.city),
        ui.string(`${i18n}.district`, resource?.district),
        ui.string(`${i18n}.postalCode`, resource?.postalCode),
        ui.string(`${i18n}.country`, resource?.country),
        ui.codeableConcept(`${i18n}.addressType`, resource?.addressType)
      ]
    };
  };
  function parseNlCoreAddressInformation(value2) {
    const lineMeta = value2?._line?.[0];
    const streetName = extension(
      lineMeta,
      "http://hl7.org/fhir/StructureDefinition/iso21090-ADXP-streetName",
      // NOSONAR
      "string"
    );
    const houseNumber = extension(
      lineMeta,
      "http://hl7.org/fhir/StructureDefinition/iso21090-ADXP-houseNumber",
      // NOSONAR
      "string"
    );
    const houseNumberAddition = extension(
      lineMeta,
      "http://hl7.org/fhir/StructureDefinition/iso21090-ADXP-buildingNumberSuffix",
      // NOSONAR
      "string"
    );
    const houseNumberIndication = extension(
      lineMeta,
      "http://hl7.org/fhir/StructureDefinition/iso21090-ADXP-additionalLocator",
      // NOSONAR
      "string"
    );
    const additionalInformation = extension(
      lineMeta,
      "http://hl7.org/fhir/StructureDefinition/iso21090-ADXP-unitID",
      // NOSONAR
      "string"
    );
    const countryCode = extension(
      value2?._country,
      "http://nictiz.nl/fhir/StructureDefinition/ext-CodeSpecification",
      // NOSONAR
      "codeableConcept"
    );
    const addressType = extension(
      value2,
      "http://nictiz.nl/fhir/StructureDefinition/ext-AddressInformation.AddressType",
      // NOSONAR
      "codeableConcept"
    );
    return {
      line: string$1(value2?.line?.[0]),
      streetName,
      houseNumber,
      houseNumberAddition,
      houseNumberIndication,
      additionalInformation,
      city: string$1(value2?.city),
      district: string$1(value2?.district),
      postalCode: string$1(value2?.postalCode),
      country: string$1(value2?.country),
      countryCode,
      addressType,
      period: period$1(value2?.period)
    };
  }
  const nlCoreAddressInformation = {
    parse: parseNlCoreAddressInformation,
    uiSchemaGroup: uiSchemaGroup$4
  };
  const uiSchemaGroup$3 = (resource, context) => {
    const i18n = "nl_core_contact_information_email_addresses";
    const ui = context.ui;
    return {
      label: i18n,
      children: [
        ui.string(`${i18n}.value`, resource?.value),
        ui.string(`${i18n}.use`, resource?.use)
      ]
    };
  };
  function parseNlCoreContactInformationEmailAddresses(value2) {
    if (value2?.system !== "email") return;
    return {
      system: value2.system,
      value: string$1(value2?.value),
      use: code$1(value2?.use)
    };
  }
  const nlCoreContactInformationEmailAddresses = {
    parse: parseNlCoreContactInformationEmailAddresses,
    uiSchemaGroup: uiSchemaGroup$3
  };
  const uiSchemaGroup$2 = (resource, context) => {
    const i18n = "nl_core_contact_information_telephone_numbers";
    const ui = context.ui;
    return {
      label: i18n,
      children: [
        ui.string(`${i18n}.value`, resource?.value),
        ui.string(`${i18n}.use`, resource?.use),
        ui.string(`${i18n}.comment`, resource?.comment),
        ui.codeableConcept(`${i18n}.telecomType`, resource?.telecomType)
      ]
    };
  };
  function parseNlCoreContactInformationTelephoneNumbers(value2) {
    if (value2?.system !== "phone") return;
    return {
      system: value2.system,
      telecomType: extension(
        value2._system,
        "http://nictiz.nl/fhir/StructureDefinition/ext-CodeSpecification",
        // NOSONAR
        "codeableConcept"
      ),
      value: string$1(value2?.value),
      use: code$1(value2?.use),
      comment: extension(
        value2,
        "http://nictiz.nl/fhir/StructureDefinition/ext-Comment",
        // NOSONAR
        "string"
      )
    };
  }
  const nlCoreContactInformationTelephoneNumbers = {
    parse: parseNlCoreContactInformationTelephoneNumbers,
    uiSchemaGroup: uiSchemaGroup$2
  };
  const uiSchema$2 = (resource, context) => {
    const i18n = "nl_core_patient";
    const ui = context.ui;
    const name = map(resource.name, (x) => nlCoreNameInformation.uiSchemaGroup(x, context), true);
    const addresses = map(
      resource.address,
      (x) => nlCoreAddressInformation.uiSchemaGroup(x, context),
      true
    );
    return {
      label: resource.name?.at(0)?.text,
      children: [
        ...name,
        {
          label: `${i18n}.group_details`,
          children: [
            ui.identifier(`${i18n}.identifier`, resource.identifier),
            ui.date(`${i18n}.birth_date`, resource.birthDate),
            ui.boolean(`${i18n}.deceased`, resource.deceased),
            ui.dateTime(`${i18n}.deceased_date_time`, resource.deceasedDateTime),
            ui.code(`${i18n}.gender`, resource.gender),
            ui.reference(`${i18n}.general_practitioner`, resource.generalPractitioner),
            ui.reference(`${i18n}.managing_organization`, resource.managingOrganization),
            ui.codeableConcept(`${i18n}.marital_status`, resource.maritalStatus),
            ui.boolean(`${i18n}.multiple_birth`, resource.multipleBirth)
          ]
        },
        ...addresses
      ]
    };
  };
  const profile$2 = "http://nictiz.nl/fhir/StructureDefinition/nl-core-Patient";
  function parseNlCorePatient(resource) {
    return {
      ...resourceMeta(resource, profile$2, FhirVersion.R4),
      name: map(resource.name, nlCoreNameInformation.parse),
      identifier: map(resource.identifier, identifier$1),
      // NL-CM:0.1.7
      birthDate: date$4(resource.birthDate),
      // NL-CM:0.1.10
      gender: code$1(resource.gender),
      // NL-CM:0.1.9
      multipleBirth: boolean$1(resource.multipleBirthBoolean),
      // NL-CM:0.1.31
      deceased: boolean$1(resource.deceasedBoolean),
      // NL-CM:0.1.32
      deceasedDateTime: dateTime$3(resource.deceasedDateTime),
      // NL-CM:0.1.33
      address: map(resource?.address, nlCoreAddressInformation.parse),
      generalPractitioner: map(resource.generalPractitioner, reference$1),
      managingOrganization: reference$1(resource.managingOrganization),
      maritalStatus: codeableConcept$1(resource.maritalStatus)
    };
  }
  const nlCorePatientR4 = {
    profile: profile$2,
    parse: parseNlCorePatient,
    uiSchema: uiSchema$2
  };
  const uiSchemaGroup$1 = (resource, context) => {
    const profile2 = "nl_core_health_professional_practitioner.qualification";
    const ui = context.ui;
    return {
      label: `${profile2}.group_details`,
      children: [
        ui.identifier(`${profile2}.identifier`, resource.identifier),
        ui.codeableConcept(`${profile2}.code`, resource.code),
        ...ui.period(`${profile2}.period`, resource.period),
        ui.reference(`${profile2}.issuer`, resource.issuer)
      ]
    };
  };
  const uiSchema$1 = (resource, context) => {
    const profile2 = "nl_core_health_professional_practitioner";
    const ui = context.ui;
    const address = map(
      resource.address,
      (x) => nlCoreAddressInformation.uiSchemaGroup(x, context),
      true
    );
    const name = map(resource.name, (x) => nlCoreNameInformation.uiSchemaGroup(x, context), true);
    const emailAddresses = map(
      resource.emailAddresses,
      (x) => nlCoreContactInformationEmailAddresses.uiSchemaGroup(x, context),
      true
    );
    const telephoneNumbers = map(
      resource.telephoneNumbers,
      (x) => nlCoreContactInformationTelephoneNumbers.uiSchemaGroup(x, context),
      true
    );
    const qualification2 = map(
      resource.qualification,
      (x) => uiSchemaGroup$1(x, context),
      true
    );
    return {
      label: resource.name?.at(0)?.text,
      children: [
        {
          label: `${profile2}.group_details`,
          children: [
            ui.identifier(`${profile2}.identifier`, resource.identifier),
            ui.code(`${profile2}.gender`, resource.gender),
            ui.date(`${profile2}.birth_date`, resource.birthDate),
            ui.codeableConcept(`${profile2}.communication`, resource.communication)
          ]
        },
        ...name,
        ...emailAddresses,
        ...telephoneNumbers,
        ...address,
        ...qualification2
      ]
    };
  };
  function parseQualification(value2) {
    return {
      identifier: map(value2?.identifier, identifier$1),
      code: codeableConcept$1(value2?.code),
      period: period$1(value2?.period),
      issuer: reference$1(value2?.issuer)
    };
  }
  const qualification = {
    parse: parseQualification,
    uiSchemaGroup: uiSchemaGroup$1
  };
  const profile$1 = "http://nictiz.nl/fhir/StructureDefinition/nl-core-HealthProfessional-Practitioner";
  function parseNlCoreHealthProfessionalPractitioner(resource) {
    return {
      ...resourceMeta(resource, profile$1, FhirVersion.R4),
      identifier: map(resource.identifier, identifier$1),
      // NL-CM:17.1.2
      name: map(resource.name, nlCoreNameInformation.parse),
      // NL-CM:17.1.3
      telephoneNumbers: map(resource.telecom, nlCoreContactInformationTelephoneNumbers.parse),
      // NL-CM-20.6.2
      emailAddresses: map(resource.telecom, nlCoreContactInformationEmailAddresses.parse),
      // NL-CM-20.6.3
      address: map(resource.address, nlCoreAddressInformation.parse),
      // NL-CM:17.1.7
      gender: code$1(resource.gender),
      // NL-CM:17.1.9
      birthDate: date$4(resource.birthDate),
      qualification: map(resource.qualification, qualification.parse),
      communication: map(resource.communication, codeableConcept$1)
    };
  }
  const nlCoreHealthProfessionalPractitioner = {
    profile: profile$1,
    parse: parseNlCoreHealthProfessionalPractitioner,
    uiSchema: uiSchema$1
  };
  const uiSchemaGroup = (resource, context) => {
    const profile2 = "r4.nl_core_vaccination_event.protocol_applied";
    const { ui, formatMessage: formatMessage2 } = context;
    return {
      label: formatMessage2(profile2),
      children: [
        ui.reference(`${profile2}.authority`, resource.authority),
        ui.codeableConcept(`${profile2}.targetDisease`, resource.targetDisease),
        ...ui.oneOfValueX(`${profile2}.doseNumber`, resource, "doseNumber"),
        ...ui.oneOfValueX(`${profile2}.seriesDoses`, resource, "seriesDoses")
      ]
    };
  };
  const uiSchema = (resource, context) => {
    const profile2 = "r4.nl_core_vaccination_event";
    const { ui, formatMessage: formatMessage2, setEmptyEntries: setEmptyEntries2 } = context;
    const artDecorDatasetVaccinationImmunization = {
      PharmaceuticalProduct: ui.reference(
        `${profile2}.pharmaceutical_product`,
        resource.pharmaceuticalProduct
      ),
      Identifier: ui.identifier(`${profile2}.identifier`, resource.identifier),
      Status: ui.string(`${profile2}.status`, resource.status),
      Patient: ui.reference(`${profile2}.patient`, resource.patient),
      Location: ui.reference(`${profile2}.location`, resource.location),
      Route: ui.codeableConcept(`${profile2}.route`, resource.route),
      Site: ui.codeableConcept(`${profile2}.site`, resource.site),
      Performer: map(resource.performer, (x) => ui.reference(`${profile2}.performer`, x), true),
      VaccinationIndication: ui.codeableConcept(
        `${profile2}.vaccination_indication`,
        resource.vaccinationIndication
      ),
      VaccinationMotive: ui.codeableConcept(
        `${profile2}.vaccination_motive`,
        resource.vaccinationMotive
      ),
      ProtocolApplied: map(
        resource.protocolApplied,
        (x) => uiSchemaGroup(x, context),
        true
      )
    };
    const zibVaccinationv4 = {
      VaccineCode: ui.codeableConcept(`${profile2}.vaccine_code`, resource.vaccineCode),
      OccurrenceDateTime: ui.dateTime(
        `${profile2}.occurrence_date_time`,
        resource.occurrenceDateTime
      ),
      DoseQuantity: ui.quantity(`${profile2}.dose_quantity`, resource.doseQuantity),
      Note: ui.annotation(`${profile2}.note`, resource.note)
    };
    return setEmptyEntries2({
      label: resource.vaccineCode?.coding?.at(0)?.display,
      children: [
        {
          label: formatMessage2(`fhir.group_general_info`),
          children: [
            zibVaccinationv4.VaccineCode,
            zibVaccinationv4.DoseQuantity,
            artDecorDatasetVaccinationImmunization.Patient,
            zibVaccinationv4.OccurrenceDateTime,
            zibVaccinationv4.Note
          ]
        },
        {
          label: formatMessage2(`${profile2}.performed_by`),
          children: [
            ...artDecorDatasetVaccinationImmunization.Performer,
            artDecorDatasetVaccinationImmunization.Location
          ]
        },
        {
          label: formatMessage2(`${profile2}.extra`),
          children: [
            artDecorDatasetVaccinationImmunization.VaccinationMotive,
            ...ui.helpers.getChildren(
              artDecorDatasetVaccinationImmunization.ProtocolApplied
            ),
            artDecorDatasetVaccinationImmunization.Route,
            artDecorDatasetVaccinationImmunization.Site
          ]
        }
      ]
    });
  };
  var VaccinationMotive = /* @__PURE__ */ ((VaccinationMotive2) => {
    VaccinationMotive2["VACCINATION_NEEDED_AS_PART_OF_IMMUNIZATION_PROGRAMME"] = "159741000146107";
    VaccinationMotive2["VACCINATION_NEEDED_AS_PART_OF_NATIONAL_IMMUNIZATION_PROGRAMME"] = "159731000146104";
    VaccinationMotive2["OCCUPATIONAL_VACCINATION_NEEDED"] = "159721000146101";
    VaccinationMotive2["ACTIVE_IMMUNIZATION"] = "33879002";
    VaccinationMotive2["PASSIVE_IMMUNISATION"] = "51116004";
    VaccinationMotive2["ELECTIVE_IMMUNIZATION_FOR_INTERNATIONAL_TRAVEL"] = "14747002";
    return VaccinationMotive2;
  })(VaccinationMotive || {});
  var VaccinationIndication = /* @__PURE__ */ ((VaccinationIndication2) => {
    VaccinationIndication2["FRAIL_ELDERLY"] = "404904002";
    VaccinationIndication2["DISORDER_OF_LUNG"] = "19829001";
    VaccinationIndication2["OVERWEIGHT"] = "238131007";
    VaccinationIndication2["IMMUNODEFICIENCY_DISORDER"] = "234532001";
    VaccinationIndication2["PREGNANCY"] = "77386006";
    VaccinationIndication2["WOUND"] = "416462003";
    return VaccinationIndication2;
  })(VaccinationIndication || {});
  function parseProtocolApplied(value2) {
    return {
      authority: reference$1(value2?.authority),
      targetDisease: map(value2?.targetDisease, codeableConcept$1),
      ...oneOfValueX$1(value2, ["string", "positiveInt"], "doseNumber"),
      ...oneOfValueX$1(value2, ["string", "positiveInt"], "seriesDoses")
    };
  }
  const profile = "http://nictiz.nl/fhir/StructureDefinition/nl-core-Vaccination-event";
  function parseNlCoreVaccinationEvent(resource) {
    const vaccinationIndication = filterCodeableConceptByCoding(
      resource.reasonCode,
      (x) => x.code && x.code in VaccinationIndication
    );
    const vaccinationMotive = filterCodeableConceptByCoding(
      resource.reasonCode,
      (x) => x.code && x.code in VaccinationMotive
    );
    return {
      ...resourceMeta(resource, profile, FhirVersion.R4),
      pharmaceuticalProduct: extensionNictiz(
        resource,
        "ext-Vaccination.PharmaceuticalProduct"
      ),
      // NL-CM:9.7.19926
      identifier: map(resource.identifier, identifier$1),
      status: string$1(resource.status),
      // imm-dataelement-144
      vaccineCode: codeableConcept$1(resource.vaccineCode),
      // NL-CM:9.7.19927
      patient: reference$1(resource.patient),
      // NL-CM:0.1.1
      occurrenceDateTime: dateTime$3(resource.occurrenceDateTime),
      // NL-CM:11.1.3
      location: reference$1(resource.location),
      // NL-CM:17.2.1 | NL-CM:17.2.9
      site: codeableConcept$1(resource.site),
      // NL-CM:20.7.4
      route: codeableConcept$1(resource.route),
      // NL-CM:9.13.21195
      doseQuantity: quantity$1(resource.doseQuantity),
      // NL-CM:11.1.4
      performer: map(resource.performer, (p) => reference$1(p.actor)),
      // NL-CM:17.1.1
      note: map(resource.note, annotation$1),
      // NL-CM:11.1.7
      vaccinationIndication: map(vaccinationIndication, codeableConcept$1),
      // imm-dataelement-160
      vaccinationMotive: map(vaccinationMotive, codeableConcept$1),
      // imm-dataelement-158
      protocolApplied: map(resource.protocolApplied, parseProtocolApplied)
    };
  }
  const nlCoreVaccinationEvent = {
    profile,
    parse: parseNlCoreVaccinationEvent,
    uiSchema
  };
  const resourcesR4 = /* @__PURE__ */ Object.freeze(/* @__PURE__ */ Object.defineProperty({
    __proto__: null,
    nlCoreHealthProfessionalPractitioner,
    nlCorePatientR4,
    nlCoreVaccinationEvent
  }, Symbol.toStringTag, { value: "Module" }));
  const resourcesMapR3 = Object.fromEntries(
    Object.entries(resourcesR3).map(([_name, config]) => [config.profile, config])
  );
  const resourcesMapR4 = Object.fromEntries(
    Object.entries(resourcesR4).map(([_name, config]) => [config.profile, config])
  );
  function getResourceConfig$1(resource, fhirVersion) {
    const resourcesMap = fhirVersion === FhirVersion.R3 ? resourcesMapR3 : resourcesMapR4;
    const profiles = resource.meta?.profile ?? [];
    for (const profile2 of profiles) {
      const config = resourcesMap[profile2];
      if (config) return config;
    }
    console.error(
      `No config found for fhir resourceType: "${resource.resourceType}" with profile: "${resource.meta?.profile}" for fhir version: "${fhirVersion}"`
    );
  }
  function getMgoResource(resource, fhirVersion) {
    const config = getResourceConfig$1(resource, fhirVersion);
    if (!config) return;
    return config.parse(resource);
  }
  function getMgoResourceJson(fhirResourceJson, fhirVersion = FhirVersion.R3) {
    const fhirResource = losslessParse(fhirResourceJson);
    if (!isFhirResource(fhirResource)) {
      throw new Error(
        `input does not seem to be a valid Fhir Resource. Received resourceType: "${fhirResource?.resourceType}"`
      );
    }
    const result = getMgoResource(fhirResource, fhirVersion);
    return losslessStringify(result);
  }
  function isMgoResource(value2) {
    const resourceTyped = value2;
    return !!resourceTyped?.id && !!resourceTyped?.resourceType && !!resourceTyped?.profile;
  }
  var extendStatics = function(d, b) {
    extendStatics = Object.setPrototypeOf || { __proto__: [] } instanceof Array && function(d2, b2) {
      d2.__proto__ = b2;
    } || function(d2, b2) {
      for (var p in b2) if (Object.prototype.hasOwnProperty.call(b2, p)) d2[p] = b2[p];
    };
    return extendStatics(d, b);
  };
  function __extends(d, b) {
    if (typeof b !== "function" && b !== null)
      throw new TypeError("Class extends value " + String(b) + " is not a constructor or null");
    extendStatics(d, b);
    function __() {
      this.constructor = d;
    }
    d.prototype = b === null ? Object.create(b) : (__.prototype = b.prototype, new __());
  }
  var __assign = function() {
    __assign = Object.assign || function __assign2(t) {
      for (var s, i = 1, n = arguments.length; i < n; i++) {
        s = arguments[i];
        for (var p in s) if (Object.prototype.hasOwnProperty.call(s, p)) t[p] = s[p];
      }
      return t;
    };
    return __assign.apply(this, arguments);
  };
  function __rest(s, e) {
    var t = {};
    for (var p in s) if (Object.prototype.hasOwnProperty.call(s, p) && e.indexOf(p) < 0)
      t[p] = s[p];
    if (s != null && typeof Object.getOwnPropertySymbols === "function")
      for (var i = 0, p = Object.getOwnPropertySymbols(s); i < p.length; i++) {
        if (e.indexOf(p[i]) < 0 && Object.prototype.propertyIsEnumerable.call(s, p[i]))
          t[p[i]] = s[p[i]];
      }
    return t;
  }
  function __spreadArray(to, from, pack) {
    if (pack || arguments.length === 2) for (var i = 0, l = from.length, ar; i < l; i++) {
      if (ar || !(i in from)) {
        if (!ar) ar = Array.prototype.slice.call(from, 0, i);
        ar[i] = from[i];
      }
    }
    return to.concat(ar || Array.prototype.slice.call(from));
  }
  typeof SuppressedError === "function" ? SuppressedError : function(error, suppressed, message) {
    var e = new Error(message);
    return e.name = "SuppressedError", e.error = error, e.suppressed = suppressed, e;
  };
  function memoize(fn, options) {
    var cache = options && options.cache ? options.cache : cacheDefault;
    var serializer = options && options.serializer ? options.serializer : serializerDefault;
    var strategy = options && options.strategy ? options.strategy : strategyDefault;
    return strategy(fn, {
      cache,
      serializer
    });
  }
  function isPrimitive(value2) {
    return value2 == null || typeof value2 === "number" || typeof value2 === "boolean";
  }
  function monadic(fn, cache, serializer, arg) {
    var cacheKey = isPrimitive(arg) ? arg : serializer(arg);
    var computedValue = cache.get(cacheKey);
    if (typeof computedValue === "undefined") {
      computedValue = fn.call(this, arg);
      cache.set(cacheKey, computedValue);
    }
    return computedValue;
  }
  function variadic(fn, cache, serializer) {
    var args = Array.prototype.slice.call(arguments, 3);
    var cacheKey = serializer(args);
    var computedValue = cache.get(cacheKey);
    if (typeof computedValue === "undefined") {
      computedValue = fn.apply(this, args);
      cache.set(cacheKey, computedValue);
    }
    return computedValue;
  }
  function assemble(fn, context, strategy, cache, serialize) {
    return strategy.bind(context, fn, cache, serialize);
  }
  function strategyDefault(fn, options) {
    var strategy = fn.length === 1 ? monadic : variadic;
    return assemble(fn, this, strategy, options.cache.create(), options.serializer);
  }
  function strategyVariadic(fn, options) {
    return assemble(fn, this, variadic, options.cache.create(), options.serializer);
  }
  function strategyMonadic(fn, options) {
    return assemble(fn, this, monadic, options.cache.create(), options.serializer);
  }
  var serializerDefault = function() {
    return JSON.stringify(arguments);
  };
  function ObjectWithoutPrototypeCache() {
    this.cache = /* @__PURE__ */ Object.create(null);
  }
  ObjectWithoutPrototypeCache.prototype.get = function(key) {
    return this.cache[key];
  };
  ObjectWithoutPrototypeCache.prototype.set = function(key, value2) {
    this.cache[key] = value2;
  };
  var cacheDefault = {
    create: function create() {
      return new ObjectWithoutPrototypeCache();
    }
  };
  var strategies = {
    variadic: strategyVariadic,
    monadic: strategyMonadic
  };
  var ErrorKind;
  (function(ErrorKind2) {
    ErrorKind2[ErrorKind2["EXPECT_ARGUMENT_CLOSING_BRACE"] = 1] = "EXPECT_ARGUMENT_CLOSING_BRACE";
    ErrorKind2[ErrorKind2["EMPTY_ARGUMENT"] = 2] = "EMPTY_ARGUMENT";
    ErrorKind2[ErrorKind2["MALFORMED_ARGUMENT"] = 3] = "MALFORMED_ARGUMENT";
    ErrorKind2[ErrorKind2["EXPECT_ARGUMENT_TYPE"] = 4] = "EXPECT_ARGUMENT_TYPE";
    ErrorKind2[ErrorKind2["INVALID_ARGUMENT_TYPE"] = 5] = "INVALID_ARGUMENT_TYPE";
    ErrorKind2[ErrorKind2["EXPECT_ARGUMENT_STYLE"] = 6] = "EXPECT_ARGUMENT_STYLE";
    ErrorKind2[ErrorKind2["INVALID_NUMBER_SKELETON"] = 7] = "INVALID_NUMBER_SKELETON";
    ErrorKind2[ErrorKind2["INVALID_DATE_TIME_SKELETON"] = 8] = "INVALID_DATE_TIME_SKELETON";
    ErrorKind2[ErrorKind2["EXPECT_NUMBER_SKELETON"] = 9] = "EXPECT_NUMBER_SKELETON";
    ErrorKind2[ErrorKind2["EXPECT_DATE_TIME_SKELETON"] = 10] = "EXPECT_DATE_TIME_SKELETON";
    ErrorKind2[ErrorKind2["UNCLOSED_QUOTE_IN_ARGUMENT_STYLE"] = 11] = "UNCLOSED_QUOTE_IN_ARGUMENT_STYLE";
    ErrorKind2[ErrorKind2["EXPECT_SELECT_ARGUMENT_OPTIONS"] = 12] = "EXPECT_SELECT_ARGUMENT_OPTIONS";
    ErrorKind2[ErrorKind2["EXPECT_PLURAL_ARGUMENT_OFFSET_VALUE"] = 13] = "EXPECT_PLURAL_ARGUMENT_OFFSET_VALUE";
    ErrorKind2[ErrorKind2["INVALID_PLURAL_ARGUMENT_OFFSET_VALUE"] = 14] = "INVALID_PLURAL_ARGUMENT_OFFSET_VALUE";
    ErrorKind2[ErrorKind2["EXPECT_SELECT_ARGUMENT_SELECTOR"] = 15] = "EXPECT_SELECT_ARGUMENT_SELECTOR";
    ErrorKind2[ErrorKind2["EXPECT_PLURAL_ARGUMENT_SELECTOR"] = 16] = "EXPECT_PLURAL_ARGUMENT_SELECTOR";
    ErrorKind2[ErrorKind2["EXPECT_SELECT_ARGUMENT_SELECTOR_FRAGMENT"] = 17] = "EXPECT_SELECT_ARGUMENT_SELECTOR_FRAGMENT";
    ErrorKind2[ErrorKind2["EXPECT_PLURAL_ARGUMENT_SELECTOR_FRAGMENT"] = 18] = "EXPECT_PLURAL_ARGUMENT_SELECTOR_FRAGMENT";
    ErrorKind2[ErrorKind2["INVALID_PLURAL_ARGUMENT_SELECTOR"] = 19] = "INVALID_PLURAL_ARGUMENT_SELECTOR";
    ErrorKind2[ErrorKind2["DUPLICATE_PLURAL_ARGUMENT_SELECTOR"] = 20] = "DUPLICATE_PLURAL_ARGUMENT_SELECTOR";
    ErrorKind2[ErrorKind2["DUPLICATE_SELECT_ARGUMENT_SELECTOR"] = 21] = "DUPLICATE_SELECT_ARGUMENT_SELECTOR";
    ErrorKind2[ErrorKind2["MISSING_OTHER_CLAUSE"] = 22] = "MISSING_OTHER_CLAUSE";
    ErrorKind2[ErrorKind2["INVALID_TAG"] = 23] = "INVALID_TAG";
    ErrorKind2[ErrorKind2["INVALID_TAG_NAME"] = 25] = "INVALID_TAG_NAME";
    ErrorKind2[ErrorKind2["UNMATCHED_CLOSING_TAG"] = 26] = "UNMATCHED_CLOSING_TAG";
    ErrorKind2[ErrorKind2["UNCLOSED_TAG"] = 27] = "UNCLOSED_TAG";
  })(ErrorKind || (ErrorKind = {}));
  var TYPE;
  (function(TYPE2) {
    TYPE2[TYPE2["literal"] = 0] = "literal";
    TYPE2[TYPE2["argument"] = 1] = "argument";
    TYPE2[TYPE2["number"] = 2] = "number";
    TYPE2[TYPE2["date"] = 3] = "date";
    TYPE2[TYPE2["time"] = 4] = "time";
    TYPE2[TYPE2["select"] = 5] = "select";
    TYPE2[TYPE2["plural"] = 6] = "plural";
    TYPE2[TYPE2["pound"] = 7] = "pound";
    TYPE2[TYPE2["tag"] = 8] = "tag";
  })(TYPE || (TYPE = {}));
  var SKELETON_TYPE;
  (function(SKELETON_TYPE2) {
    SKELETON_TYPE2[SKELETON_TYPE2["number"] = 0] = "number";
    SKELETON_TYPE2[SKELETON_TYPE2["dateTime"] = 1] = "dateTime";
  })(SKELETON_TYPE || (SKELETON_TYPE = {}));
  function isLiteralElement(el) {
    return el.type === TYPE.literal;
  }
  function isArgumentElement(el) {
    return el.type === TYPE.argument;
  }
  function isNumberElement(el) {
    return el.type === TYPE.number;
  }
  function isDateElement(el) {
    return el.type === TYPE.date;
  }
  function isTimeElement(el) {
    return el.type === TYPE.time;
  }
  function isSelectElement(el) {
    return el.type === TYPE.select;
  }
  function isPluralElement(el) {
    return el.type === TYPE.plural;
  }
  function isPoundElement(el) {
    return el.type === TYPE.pound;
  }
  function isTagElement(el) {
    return el.type === TYPE.tag;
  }
  function isNumberSkeleton(el) {
    return !!(el && typeof el === "object" && el.type === SKELETON_TYPE.number);
  }
  function isDateTimeSkeleton(el) {
    return !!(el && typeof el === "object" && el.type === SKELETON_TYPE.dateTime);
  }
  var SPACE_SEPARATOR_REGEX = /[ \xA0\u1680\u2000-\u200A\u202F\u205F\u3000]/;
  var DATE_TIME_REGEX = /(?:[Eec]{1,6}|G{1,5}|[Qq]{1,5}|(?:[yYur]+|U{1,5})|[ML]{1,5}|d{1,2}|D{1,3}|F{1}|[abB]{1,5}|[hkHK]{1,2}|w{1,2}|W{1}|m{1,2}|s{1,2}|[zZOvVxX]{1,4})(?=([^']*'[^']*')*[^']*$)/g;
  function parseDateTimeSkeleton(skeleton) {
    var result = {};
    skeleton.replace(DATE_TIME_REGEX, function(match) {
      var len = match.length;
      switch (match[0]) {
        case "G":
          result.era = len === 4 ? "long" : len === 5 ? "narrow" : "short";
          break;
        case "y":
          result.year = len === 2 ? "2-digit" : "numeric";
          break;
        case "Y":
        case "u":
        case "U":
        case "r":
          throw new RangeError("`Y/u/U/r` (year) patterns are not supported, use `y` instead");
        case "q":
        case "Q":
          throw new RangeError("`q/Q` (quarter) patterns are not supported");
        case "M":
        case "L":
          result.month = ["numeric", "2-digit", "short", "long", "narrow"][len - 1];
          break;
        case "w":
        case "W":
          throw new RangeError("`w/W` (week) patterns are not supported");
        case "d":
          result.day = ["numeric", "2-digit"][len - 1];
          break;
        case "D":
        case "F":
        case "g":
          throw new RangeError("`D/F/g` (day) patterns are not supported, use `d` instead");
        case "E":
          result.weekday = len === 4 ? "long" : len === 5 ? "narrow" : "short";
          break;
        case "e":
          if (len < 4) {
            throw new RangeError("`e..eee` (weekday) patterns are not supported");
          }
          result.weekday = ["short", "long", "narrow", "short"][len - 4];
          break;
        case "c":
          if (len < 4) {
            throw new RangeError("`c..ccc` (weekday) patterns are not supported");
          }
          result.weekday = ["short", "long", "narrow", "short"][len - 4];
          break;
        case "a":
          result.hour12 = true;
          break;
        case "b":
        case "B":
          throw new RangeError("`b/B` (period) patterns are not supported, use `a` instead");
        case "h":
          result.hourCycle = "h12";
          result.hour = ["numeric", "2-digit"][len - 1];
          break;
        case "H":
          result.hourCycle = "h23";
          result.hour = ["numeric", "2-digit"][len - 1];
          break;
        case "K":
          result.hourCycle = "h11";
          result.hour = ["numeric", "2-digit"][len - 1];
          break;
        case "k":
          result.hourCycle = "h24";
          result.hour = ["numeric", "2-digit"][len - 1];
          break;
        case "j":
        case "J":
        case "C":
          throw new RangeError("`j/J/C` (hour) patterns are not supported, use `h/H/K/k` instead");
        case "m":
          result.minute = ["numeric", "2-digit"][len - 1];
          break;
        case "s":
          result.second = ["numeric", "2-digit"][len - 1];
          break;
        case "S":
        case "A":
          throw new RangeError("`S/A` (second) patterns are not supported, use `s` instead");
        case "z":
          result.timeZoneName = len < 4 ? "short" : "long";
          break;
        case "Z":
        case "O":
        case "v":
        case "V":
        case "X":
        case "x":
          throw new RangeError("`Z/O/v/V/X/x` (timeZone) patterns are not supported, use `z` instead");
      }
      return "";
    });
    return result;
  }
  var WHITE_SPACE_REGEX = /[\t-\r \x85\u200E\u200F\u2028\u2029]/i;
  function parseNumberSkeletonFromString(skeleton) {
    if (skeleton.length === 0) {
      throw new Error("Number skeleton cannot be empty");
    }
    var stringTokens = skeleton.split(WHITE_SPACE_REGEX).filter(function(x) {
      return x.length > 0;
    });
    var tokens = [];
    for (var _i = 0, stringTokens_1 = stringTokens; _i < stringTokens_1.length; _i++) {
      var stringToken = stringTokens_1[_i];
      var stemAndOptions = stringToken.split("/");
      if (stemAndOptions.length === 0) {
        throw new Error("Invalid number skeleton");
      }
      var stem = stemAndOptions[0], options = stemAndOptions.slice(1);
      for (var _a2 = 0, options_1 = options; _a2 < options_1.length; _a2++) {
        var option = options_1[_a2];
        if (option.length === 0) {
          throw new Error("Invalid number skeleton");
        }
      }
      tokens.push({ stem, options });
    }
    return tokens;
  }
  function icuUnitToEcma(unit) {
    return unit.replace(/^(.*?)-/, "");
  }
  var FRACTION_PRECISION_REGEX = /^\.(?:(0+)(\*)?|(#+)|(0+)(#+))$/g;
  var SIGNIFICANT_PRECISION_REGEX = /^(@+)?(\+|#+)?[rs]?$/g;
  var INTEGER_WIDTH_REGEX = /(\*)(0+)|(#+)(0+)|(0+)/g;
  var CONCISE_INTEGER_WIDTH_REGEX = /^(0+)$/;
  function parseSignificantPrecision(str) {
    var result = {};
    if (str[str.length - 1] === "r") {
      result.roundingPriority = "morePrecision";
    } else if (str[str.length - 1] === "s") {
      result.roundingPriority = "lessPrecision";
    }
    str.replace(SIGNIFICANT_PRECISION_REGEX, function(_, g1, g2) {
      if (typeof g2 !== "string") {
        result.minimumSignificantDigits = g1.length;
        result.maximumSignificantDigits = g1.length;
      } else if (g2 === "+") {
        result.minimumSignificantDigits = g1.length;
      } else if (g1[0] === "#") {
        result.maximumSignificantDigits = g1.length;
      } else {
        result.minimumSignificantDigits = g1.length;
        result.maximumSignificantDigits = g1.length + (typeof g2 === "string" ? g2.length : 0);
      }
      return "";
    });
    return result;
  }
  function parseSign(str) {
    switch (str) {
      case "sign-auto":
        return {
          signDisplay: "auto"
        };
      case "sign-accounting":
      case "()":
        return {
          currencySign: "accounting"
        };
      case "sign-always":
      case "+!":
        return {
          signDisplay: "always"
        };
      case "sign-accounting-always":
      case "()!":
        return {
          signDisplay: "always",
          currencySign: "accounting"
        };
      case "sign-except-zero":
      case "+?":
        return {
          signDisplay: "exceptZero"
        };
      case "sign-accounting-except-zero":
      case "()?":
        return {
          signDisplay: "exceptZero",
          currencySign: "accounting"
        };
      case "sign-never":
      case "+_":
        return {
          signDisplay: "never"
        };
    }
  }
  function parseConciseScientificAndEngineeringStem(stem) {
    var result;
    if (stem[0] === "E" && stem[1] === "E") {
      result = {
        notation: "engineering"
      };
      stem = stem.slice(2);
    } else if (stem[0] === "E") {
      result = {
        notation: "scientific"
      };
      stem = stem.slice(1);
    }
    if (result) {
      var signDisplay = stem.slice(0, 2);
      if (signDisplay === "+!") {
        result.signDisplay = "always";
        stem = stem.slice(2);
      } else if (signDisplay === "+?") {
        result.signDisplay = "exceptZero";
        stem = stem.slice(2);
      }
      if (!CONCISE_INTEGER_WIDTH_REGEX.test(stem)) {
        throw new Error("Malformed concise eng/scientific notation");
      }
      result.minimumIntegerDigits = stem.length;
    }
    return result;
  }
  function parseNotationOptions(opt) {
    var result = {};
    var signOpts = parseSign(opt);
    if (signOpts) {
      return signOpts;
    }
    return result;
  }
  function parseNumberSkeleton(tokens) {
    var result = {};
    for (var _i = 0, tokens_1 = tokens; _i < tokens_1.length; _i++) {
      var token = tokens_1[_i];
      switch (token.stem) {
        case "percent":
        case "%":
          result.style = "percent";
          continue;
        case "%x100":
          result.style = "percent";
          result.scale = 100;
          continue;
        case "currency":
          result.style = "currency";
          result.currency = token.options[0];
          continue;
        case "group-off":
        case ",_":
          result.useGrouping = false;
          continue;
        case "precision-integer":
        case ".":
          result.maximumFractionDigits = 0;
          continue;
        case "measure-unit":
        case "unit":
          result.style = "unit";
          result.unit = icuUnitToEcma(token.options[0]);
          continue;
        case "compact-short":
        case "K":
          result.notation = "compact";
          result.compactDisplay = "short";
          continue;
        case "compact-long":
        case "KK":
          result.notation = "compact";
          result.compactDisplay = "long";
          continue;
        case "scientific":
          result = __assign(__assign(__assign({}, result), { notation: "scientific" }), token.options.reduce(function(all, opt2) {
            return __assign(__assign({}, all), parseNotationOptions(opt2));
          }, {}));
          continue;
        case "engineering":
          result = __assign(__assign(__assign({}, result), { notation: "engineering" }), token.options.reduce(function(all, opt2) {
            return __assign(__assign({}, all), parseNotationOptions(opt2));
          }, {}));
          continue;
        case "notation-simple":
          result.notation = "standard";
          continue;
        case "unit-width-narrow":
          result.currencyDisplay = "narrowSymbol";
          result.unitDisplay = "narrow";
          continue;
        case "unit-width-short":
          result.currencyDisplay = "code";
          result.unitDisplay = "short";
          continue;
        case "unit-width-full-name":
          result.currencyDisplay = "name";
          result.unitDisplay = "long";
          continue;
        case "unit-width-iso-code":
          result.currencyDisplay = "symbol";
          continue;
        case "scale":
          result.scale = parseFloat(token.options[0]);
          continue;
        case "rounding-mode-floor":
          result.roundingMode = "floor";
          continue;
        case "rounding-mode-ceiling":
          result.roundingMode = "ceil";
          continue;
        case "rounding-mode-down":
          result.roundingMode = "trunc";
          continue;
        case "rounding-mode-up":
          result.roundingMode = "expand";
          continue;
        case "rounding-mode-half-even":
          result.roundingMode = "halfEven";
          continue;
        case "rounding-mode-half-down":
          result.roundingMode = "halfTrunc";
          continue;
        case "rounding-mode-half-up":
          result.roundingMode = "halfExpand";
          continue;
        case "integer-width":
          if (token.options.length > 1) {
            throw new RangeError("integer-width stems only accept a single optional option");
          }
          token.options[0].replace(INTEGER_WIDTH_REGEX, function(_, g1, g2, g3, g4, g5) {
            if (g1) {
              result.minimumIntegerDigits = g2.length;
            } else if (g3 && g4) {
              throw new Error("We currently do not support maximum integer digits");
            } else if (g5) {
              throw new Error("We currently do not support exact integer digits");
            }
            return "";
          });
          continue;
      }
      if (CONCISE_INTEGER_WIDTH_REGEX.test(token.stem)) {
        result.minimumIntegerDigits = token.stem.length;
        continue;
      }
      if (FRACTION_PRECISION_REGEX.test(token.stem)) {
        if (token.options.length > 1) {
          throw new RangeError("Fraction-precision stems only accept a single optional option");
        }
        token.stem.replace(FRACTION_PRECISION_REGEX, function(_, g1, g2, g3, g4, g5) {
          if (g2 === "*") {
            result.minimumFractionDigits = g1.length;
          } else if (g3 && g3[0] === "#") {
            result.maximumFractionDigits = g3.length;
          } else if (g4 && g5) {
            result.minimumFractionDigits = g4.length;
            result.maximumFractionDigits = g4.length + g5.length;
          } else {
            result.minimumFractionDigits = g1.length;
            result.maximumFractionDigits = g1.length;
          }
          return "";
        });
        var opt = token.options[0];
        if (opt === "w") {
          result = __assign(__assign({}, result), { trailingZeroDisplay: "stripIfInteger" });
        } else if (opt) {
          result = __assign(__assign({}, result), parseSignificantPrecision(opt));
        }
        continue;
      }
      if (SIGNIFICANT_PRECISION_REGEX.test(token.stem)) {
        result = __assign(__assign({}, result), parseSignificantPrecision(token.stem));
        continue;
      }
      var signOpts = parseSign(token.stem);
      if (signOpts) {
        result = __assign(__assign({}, result), signOpts);
      }
      var conciseScientificAndEngineeringOpts = parseConciseScientificAndEngineeringStem(token.stem);
      if (conciseScientificAndEngineeringOpts) {
        result = __assign(__assign({}, result), conciseScientificAndEngineeringOpts);
      }
    }
    return result;
  }
  var timeData = {
    "001": [
      "H",
      "h"
    ],
    "419": [
      "h",
      "H",
      "hB",
      "hb"
    ],
    "AC": [
      "H",
      "h",
      "hb",
      "hB"
    ],
    "AD": [
      "H",
      "hB"
    ],
    "AE": [
      "h",
      "hB",
      "hb",
      "H"
    ],
    "AF": [
      "H",
      "hb",
      "hB",
      "h"
    ],
    "AG": [
      "h",
      "hb",
      "H",
      "hB"
    ],
    "AI": [
      "H",
      "h",
      "hb",
      "hB"
    ],
    "AL": [
      "h",
      "H",
      "hB"
    ],
    "AM": [
      "H",
      "hB"
    ],
    "AO": [
      "H",
      "hB"
    ],
    "AR": [
      "h",
      "H",
      "hB",
      "hb"
    ],
    "AS": [
      "h",
      "H"
    ],
    "AT": [
      "H",
      "hB"
    ],
    "AU": [
      "h",
      "hb",
      "H",
      "hB"
    ],
    "AW": [
      "H",
      "hB"
    ],
    "AX": [
      "H"
    ],
    "AZ": [
      "H",
      "hB",
      "h"
    ],
    "BA": [
      "H",
      "hB",
      "h"
    ],
    "BB": [
      "h",
      "hb",
      "H",
      "hB"
    ],
    "BD": [
      "h",
      "hB",
      "H"
    ],
    "BE": [
      "H",
      "hB"
    ],
    "BF": [
      "H",
      "hB"
    ],
    "BG": [
      "H",
      "hB",
      "h"
    ],
    "BH": [
      "h",
      "hB",
      "hb",
      "H"
    ],
    "BI": [
      "H",
      "h"
    ],
    "BJ": [
      "H",
      "hB"
    ],
    "BL": [
      "H",
      "hB"
    ],
    "BM": [
      "h",
      "hb",
      "H",
      "hB"
    ],
    "BN": [
      "hb",
      "hB",
      "h",
      "H"
    ],
    "BO": [
      "h",
      "H",
      "hB",
      "hb"
    ],
    "BQ": [
      "H"
    ],
    "BR": [
      "H",
      "hB"
    ],
    "BS": [
      "h",
      "hb",
      "H",
      "hB"
    ],
    "BT": [
      "h",
      "H"
    ],
    "BW": [
      "H",
      "h",
      "hb",
      "hB"
    ],
    "BY": [
      "H",
      "h"
    ],
    "BZ": [
      "H",
      "h",
      "hb",
      "hB"
    ],
    "CA": [
      "h",
      "hb",
      "H",
      "hB"
    ],
    "CC": [
      "H",
      "h",
      "hb",
      "hB"
    ],
    "CD": [
      "hB",
      "H"
    ],
    "CF": [
      "H",
      "h",
      "hB"
    ],
    "CG": [
      "H",
      "hB"
    ],
    "CH": [
      "H",
      "hB",
      "h"
    ],
    "CI": [
      "H",
      "hB"
    ],
    "CK": [
      "H",
      "h",
      "hb",
      "hB"
    ],
    "CL": [
      "h",
      "H",
      "hB",
      "hb"
    ],
    "CM": [
      "H",
      "h",
      "hB"
    ],
    "CN": [
      "H",
      "hB",
      "hb",
      "h"
    ],
    "CO": [
      "h",
      "H",
      "hB",
      "hb"
    ],
    "CP": [
      "H"
    ],
    "CR": [
      "h",
      "H",
      "hB",
      "hb"
    ],
    "CU": [
      "h",
      "H",
      "hB",
      "hb"
    ],
    "CV": [
      "H",
      "hB"
    ],
    "CW": [
      "H",
      "hB"
    ],
    "CX": [
      "H",
      "h",
      "hb",
      "hB"
    ],
    "CY": [
      "h",
      "H",
      "hb",
      "hB"
    ],
    "CZ": [
      "H"
    ],
    "DE": [
      "H",
      "hB"
    ],
    "DG": [
      "H",
      "h",
      "hb",
      "hB"
    ],
    "DJ": [
      "h",
      "H"
    ],
    "DK": [
      "H"
    ],
    "DM": [
      "h",
      "hb",
      "H",
      "hB"
    ],
    "DO": [
      "h",
      "H",
      "hB",
      "hb"
    ],
    "DZ": [
      "h",
      "hB",
      "hb",
      "H"
    ],
    "EA": [
      "H",
      "h",
      "hB",
      "hb"
    ],
    "EC": [
      "h",
      "H",
      "hB",
      "hb"
    ],
    "EE": [
      "H",
      "hB"
    ],
    "EG": [
      "h",
      "hB",
      "hb",
      "H"
    ],
    "EH": [
      "h",
      "hB",
      "hb",
      "H"
    ],
    "ER": [
      "h",
      "H"
    ],
    "ES": [
      "H",
      "hB",
      "h",
      "hb"
    ],
    "ET": [
      "hB",
      "hb",
      "h",
      "H"
    ],
    "FI": [
      "H"
    ],
    "FJ": [
      "h",
      "hb",
      "H",
      "hB"
    ],
    "FK": [
      "H",
      "h",
      "hb",
      "hB"
    ],
    "FM": [
      "h",
      "hb",
      "H",
      "hB"
    ],
    "FO": [
      "H",
      "h"
    ],
    "FR": [
      "H",
      "hB"
    ],
    "GA": [
      "H",
      "hB"
    ],
    "GB": [
      "H",
      "h",
      "hb",
      "hB"
    ],
    "GD": [
      "h",
      "hb",
      "H",
      "hB"
    ],
    "GE": [
      "H",
      "hB",
      "h"
    ],
    "GF": [
      "H",
      "hB"
    ],
    "GG": [
      "H",
      "h",
      "hb",
      "hB"
    ],
    "GH": [
      "h",
      "H"
    ],
    "GI": [
      "H",
      "h",
      "hb",
      "hB"
    ],
    "GL": [
      "H",
      "h"
    ],
    "GM": [
      "h",
      "hb",
      "H",
      "hB"
    ],
    "GN": [
      "H",
      "hB"
    ],
    "GP": [
      "H",
      "hB"
    ],
    "GQ": [
      "H",
      "hB",
      "h",
      "hb"
    ],
    "GR": [
      "h",
      "H",
      "hb",
      "hB"
    ],
    "GT": [
      "h",
      "H",
      "hB",
      "hb"
    ],
    "GU": [
      "h",
      "hb",
      "H",
      "hB"
    ],
    "GW": [
      "H",
      "hB"
    ],
    "GY": [
      "h",
      "hb",
      "H",
      "hB"
    ],
    "HK": [
      "h",
      "hB",
      "hb",
      "H"
    ],
    "HN": [
      "h",
      "H",
      "hB",
      "hb"
    ],
    "HR": [
      "H",
      "hB"
    ],
    "HU": [
      "H",
      "h"
    ],
    "IC": [
      "H",
      "h",
      "hB",
      "hb"
    ],
    "ID": [
      "H"
    ],
    "IE": [
      "H",
      "h",
      "hb",
      "hB"
    ],
    "IL": [
      "H",
      "hB"
    ],
    "IM": [
      "H",
      "h",
      "hb",
      "hB"
    ],
    "IN": [
      "h",
      "H"
    ],
    "IO": [
      "H",
      "h",
      "hb",
      "hB"
    ],
    "IQ": [
      "h",
      "hB",
      "hb",
      "H"
    ],
    "IR": [
      "hB",
      "H"
    ],
    "IS": [
      "H"
    ],
    "IT": [
      "H",
      "hB"
    ],
    "JE": [
      "H",
      "h",
      "hb",
      "hB"
    ],
    "JM": [
      "h",
      "hb",
      "H",
      "hB"
    ],
    "JO": [
      "h",
      "hB",
      "hb",
      "H"
    ],
    "JP": [
      "H",
      "K",
      "h"
    ],
    "KE": [
      "hB",
      "hb",
      "H",
      "h"
    ],
    "KG": [
      "H",
      "h",
      "hB",
      "hb"
    ],
    "KH": [
      "hB",
      "h",
      "H",
      "hb"
    ],
    "KI": [
      "h",
      "hb",
      "H",
      "hB"
    ],
    "KM": [
      "H",
      "h",
      "hB",
      "hb"
    ],
    "KN": [
      "h",
      "hb",
      "H",
      "hB"
    ],
    "KP": [
      "h",
      "H",
      "hB",
      "hb"
    ],
    "KR": [
      "h",
      "H",
      "hB",
      "hb"
    ],
    "KW": [
      "h",
      "hB",
      "hb",
      "H"
    ],
    "KY": [
      "h",
      "hb",
      "H",
      "hB"
    ],
    "KZ": [
      "H",
      "hB"
    ],
    "LA": [
      "H",
      "hb",
      "hB",
      "h"
    ],
    "LB": [
      "h",
      "hB",
      "hb",
      "H"
    ],
    "LC": [
      "h",
      "hb",
      "H",
      "hB"
    ],
    "LI": [
      "H",
      "hB",
      "h"
    ],
    "LK": [
      "H",
      "h",
      "hB",
      "hb"
    ],
    "LR": [
      "h",
      "hb",
      "H",
      "hB"
    ],
    "LS": [
      "h",
      "H"
    ],
    "LT": [
      "H",
      "h",
      "hb",
      "hB"
    ],
    "LU": [
      "H",
      "h",
      "hB"
    ],
    "LV": [
      "H",
      "hB",
      "hb",
      "h"
    ],
    "LY": [
      "h",
      "hB",
      "hb",
      "H"
    ],
    "MA": [
      "H",
      "h",
      "hB",
      "hb"
    ],
    "MC": [
      "H",
      "hB"
    ],
    "MD": [
      "H",
      "hB"
    ],
    "ME": [
      "H",
      "hB",
      "h"
    ],
    "MF": [
      "H",
      "hB"
    ],
    "MG": [
      "H",
      "h"
    ],
    "MH": [
      "h",
      "hb",
      "H",
      "hB"
    ],
    "MK": [
      "H",
      "h",
      "hb",
      "hB"
    ],
    "ML": [
      "H"
    ],
    "MM": [
      "hB",
      "hb",
      "H",
      "h"
    ],
    "MN": [
      "H",
      "h",
      "hb",
      "hB"
    ],
    "MO": [
      "h",
      "hB",
      "hb",
      "H"
    ],
    "MP": [
      "h",
      "hb",
      "H",
      "hB"
    ],
    "MQ": [
      "H",
      "hB"
    ],
    "MR": [
      "h",
      "hB",
      "hb",
      "H"
    ],
    "MS": [
      "H",
      "h",
      "hb",
      "hB"
    ],
    "MT": [
      "H",
      "h"
    ],
    "MU": [
      "H",
      "h"
    ],
    "MV": [
      "H",
      "h"
    ],
    "MW": [
      "h",
      "hb",
      "H",
      "hB"
    ],
    "MX": [
      "h",
      "H",
      "hB",
      "hb"
    ],
    "MY": [
      "hb",
      "hB",
      "h",
      "H"
    ],
    "MZ": [
      "H",
      "hB"
    ],
    "NA": [
      "h",
      "H",
      "hB",
      "hb"
    ],
    "NC": [
      "H",
      "hB"
    ],
    "NE": [
      "H"
    ],
    "NF": [
      "H",
      "h",
      "hb",
      "hB"
    ],
    "NG": [
      "H",
      "h",
      "hb",
      "hB"
    ],
    "NI": [
      "h",
      "H",
      "hB",
      "hb"
    ],
    "NL": [
      "H",
      "hB"
    ],
    "NO": [
      "H",
      "h"
    ],
    "NP": [
      "H",
      "h",
      "hB"
    ],
    "NR": [
      "H",
      "h",
      "hb",
      "hB"
    ],
    "NU": [
      "H",
      "h",
      "hb",
      "hB"
    ],
    "NZ": [
      "h",
      "hb",
      "H",
      "hB"
    ],
    "OM": [
      "h",
      "hB",
      "hb",
      "H"
    ],
    "PA": [
      "h",
      "H",
      "hB",
      "hb"
    ],
    "PE": [
      "h",
      "H",
      "hB",
      "hb"
    ],
    "PF": [
      "H",
      "h",
      "hB"
    ],
    "PG": [
      "h",
      "H"
    ],
    "PH": [
      "h",
      "hB",
      "hb",
      "H"
    ],
    "PK": [
      "h",
      "hB",
      "H"
    ],
    "PL": [
      "H",
      "h"
    ],
    "PM": [
      "H",
      "hB"
    ],
    "PN": [
      "H",
      "h",
      "hb",
      "hB"
    ],
    "PR": [
      "h",
      "H",
      "hB",
      "hb"
    ],
    "PS": [
      "h",
      "hB",
      "hb",
      "H"
    ],
    "PT": [
      "H",
      "hB"
    ],
    "PW": [
      "h",
      "H"
    ],
    "PY": [
      "h",
      "H",
      "hB",
      "hb"
    ],
    "QA": [
      "h",
      "hB",
      "hb",
      "H"
    ],
    "RE": [
      "H",
      "hB"
    ],
    "RO": [
      "H",
      "hB"
    ],
    "RS": [
      "H",
      "hB",
      "h"
    ],
    "RU": [
      "H"
    ],
    "RW": [
      "H",
      "h"
    ],
    "SA": [
      "h",
      "hB",
      "hb",
      "H"
    ],
    "SB": [
      "h",
      "hb",
      "H",
      "hB"
    ],
    "SC": [
      "H",
      "h",
      "hB"
    ],
    "SD": [
      "h",
      "hB",
      "hb",
      "H"
    ],
    "SE": [
      "H"
    ],
    "SG": [
      "h",
      "hb",
      "H",
      "hB"
    ],
    "SH": [
      "H",
      "h",
      "hb",
      "hB"
    ],
    "SI": [
      "H",
      "hB"
    ],
    "SJ": [
      "H"
    ],
    "SK": [
      "H"
    ],
    "SL": [
      "h",
      "hb",
      "H",
      "hB"
    ],
    "SM": [
      "H",
      "h",
      "hB"
    ],
    "SN": [
      "H",
      "h",
      "hB"
    ],
    "SO": [
      "h",
      "H"
    ],
    "SR": [
      "H",
      "hB"
    ],
    "SS": [
      "h",
      "hb",
      "H",
      "hB"
    ],
    "ST": [
      "H",
      "hB"
    ],
    "SV": [
      "h",
      "H",
      "hB",
      "hb"
    ],
    "SX": [
      "H",
      "h",
      "hb",
      "hB"
    ],
    "SY": [
      "h",
      "hB",
      "hb",
      "H"
    ],
    "SZ": [
      "h",
      "hb",
      "H",
      "hB"
    ],
    "TA": [
      "H",
      "h",
      "hb",
      "hB"
    ],
    "TC": [
      "h",
      "hb",
      "H",
      "hB"
    ],
    "TD": [
      "h",
      "H",
      "hB"
    ],
    "TF": [
      "H",
      "h",
      "hB"
    ],
    "TG": [
      "H",
      "hB"
    ],
    "TH": [
      "H",
      "h"
    ],
    "TJ": [
      "H",
      "h"
    ],
    "TL": [
      "H",
      "hB",
      "hb",
      "h"
    ],
    "TM": [
      "H",
      "h"
    ],
    "TN": [
      "h",
      "hB",
      "hb",
      "H"
    ],
    "TO": [
      "h",
      "H"
    ],
    "TR": [
      "H",
      "hB"
    ],
    "TT": [
      "h",
      "hb",
      "H",
      "hB"
    ],
    "TW": [
      "hB",
      "hb",
      "h",
      "H"
    ],
    "TZ": [
      "hB",
      "hb",
      "H",
      "h"
    ],
    "UA": [
      "H",
      "hB",
      "h"
    ],
    "UG": [
      "hB",
      "hb",
      "H",
      "h"
    ],
    "UM": [
      "h",
      "hb",
      "H",
      "hB"
    ],
    "US": [
      "h",
      "hb",
      "H",
      "hB"
    ],
    "UY": [
      "h",
      "H",
      "hB",
      "hb"
    ],
    "UZ": [
      "H",
      "hB",
      "h"
    ],
    "VA": [
      "H",
      "h",
      "hB"
    ],
    "VC": [
      "h",
      "hb",
      "H",
      "hB"
    ],
    "VE": [
      "h",
      "H",
      "hB",
      "hb"
    ],
    "VG": [
      "h",
      "hb",
      "H",
      "hB"
    ],
    "VI": [
      "h",
      "hb",
      "H",
      "hB"
    ],
    "VN": [
      "H",
      "h"
    ],
    "VU": [
      "h",
      "H"
    ],
    "WF": [
      "H",
      "hB"
    ],
    "WS": [
      "h",
      "H"
    ],
    "XK": [
      "H",
      "hB",
      "h"
    ],
    "YE": [
      "h",
      "hB",
      "hb",
      "H"
    ],
    "YT": [
      "H",
      "hB"
    ],
    "ZA": [
      "H",
      "h",
      "hb",
      "hB"
    ],
    "ZM": [
      "h",
      "hb",
      "H",
      "hB"
    ],
    "ZW": [
      "H",
      "h"
    ],
    "af-ZA": [
      "H",
      "h",
      "hB",
      "hb"
    ],
    "ar-001": [
      "h",
      "hB",
      "hb",
      "H"
    ],
    "ca-ES": [
      "H",
      "h",
      "hB"
    ],
    "en-001": [
      "h",
      "hb",
      "H",
      "hB"
    ],
    "en-HK": [
      "h",
      "hb",
      "H",
      "hB"
    ],
    "en-IL": [
      "H",
      "h",
      "hb",
      "hB"
    ],
    "en-MY": [
      "h",
      "hb",
      "H",
      "hB"
    ],
    "es-BR": [
      "H",
      "h",
      "hB",
      "hb"
    ],
    "es-ES": [
      "H",
      "h",
      "hB",
      "hb"
    ],
    "es-GQ": [
      "H",
      "h",
      "hB",
      "hb"
    ],
    "fr-CA": [
      "H",
      "h",
      "hB"
    ],
    "gl-ES": [
      "H",
      "h",
      "hB"
    ],
    "gu-IN": [
      "hB",
      "hb",
      "h",
      "H"
    ],
    "hi-IN": [
      "hB",
      "h",
      "H"
    ],
    "it-CH": [
      "H",
      "h",
      "hB"
    ],
    "it-IT": [
      "H",
      "h",
      "hB"
    ],
    "kn-IN": [
      "hB",
      "h",
      "H"
    ],
    "ml-IN": [
      "hB",
      "h",
      "H"
    ],
    "mr-IN": [
      "hB",
      "hb",
      "h",
      "H"
    ],
    "pa-IN": [
      "hB",
      "hb",
      "h",
      "H"
    ],
    "ta-IN": [
      "hB",
      "h",
      "hb",
      "H"
    ],
    "te-IN": [
      "hB",
      "h",
      "H"
    ],
    "zu-ZA": [
      "H",
      "hB",
      "hb",
      "h"
    ]
  };
  function getBestPattern(skeleton, locale) {
    var skeletonCopy = "";
    for (var patternPos = 0; patternPos < skeleton.length; patternPos++) {
      var patternChar = skeleton.charAt(patternPos);
      if (patternChar === "j") {
        var extraLength = 0;
        while (patternPos + 1 < skeleton.length && skeleton.charAt(patternPos + 1) === patternChar) {
          extraLength++;
          patternPos++;
        }
        var hourLen = 1 + (extraLength & 1);
        var dayPeriodLen = extraLength < 2 ? 1 : 3 + (extraLength >> 1);
        var dayPeriodChar = "a";
        var hourChar = getDefaultHourSymbolFromLocale(locale);
        if (hourChar == "H" || hourChar == "k") {
          dayPeriodLen = 0;
        }
        while (dayPeriodLen-- > 0) {
          skeletonCopy += dayPeriodChar;
        }
        while (hourLen-- > 0) {
          skeletonCopy = hourChar + skeletonCopy;
        }
      } else if (patternChar === "J") {
        skeletonCopy += "H";
      } else {
        skeletonCopy += patternChar;
      }
    }
    return skeletonCopy;
  }
  function getDefaultHourSymbolFromLocale(locale) {
    var hourCycle = locale.hourCycle;
    if (hourCycle === void 0 && // @ts-ignore hourCycle(s) is not identified yet
    locale.hourCycles && // @ts-ignore
    locale.hourCycles.length) {
      hourCycle = locale.hourCycles[0];
    }
    if (hourCycle) {
      switch (hourCycle) {
        case "h24":
          return "k";
        case "h23":
          return "H";
        case "h12":
          return "h";
        case "h11":
          return "K";
        default:
          throw new Error("Invalid hourCycle");
      }
    }
    var languageTag = locale.language;
    var regionTag;
    if (languageTag !== "root") {
      regionTag = locale.maximize().region;
    }
    var hourCycles = timeData[regionTag || ""] || timeData[languageTag || ""] || timeData["".concat(languageTag, "-001")] || timeData["001"];
    return hourCycles[0];
  }
  var _a;
  var SPACE_SEPARATOR_START_REGEX = new RegExp("^".concat(SPACE_SEPARATOR_REGEX.source, "*"));
  var SPACE_SEPARATOR_END_REGEX = new RegExp("".concat(SPACE_SEPARATOR_REGEX.source, "*$"));
  function createLocation(start, end) {
    return { start, end };
  }
  var hasNativeStartsWith = !!String.prototype.startsWith && "_a".startsWith("a", 1);
  var hasNativeFromCodePoint = !!String.fromCodePoint;
  var hasNativeFromEntries = !!Object.fromEntries;
  var hasNativeCodePointAt = !!String.prototype.codePointAt;
  var hasTrimStart = !!String.prototype.trimStart;
  var hasTrimEnd = !!String.prototype.trimEnd;
  var hasNativeIsSafeInteger = !!Number.isSafeInteger;
  var isSafeInteger = hasNativeIsSafeInteger ? Number.isSafeInteger : function(n) {
    return typeof n === "number" && isFinite(n) && Math.floor(n) === n && Math.abs(n) <= 9007199254740991;
  };
  var REGEX_SUPPORTS_U_AND_Y = true;
  try {
    var re = RE("([^\\p{White_Space}\\p{Pattern_Syntax}]*)", "yu");
    REGEX_SUPPORTS_U_AND_Y = ((_a = re.exec("a")) === null || _a === void 0 ? void 0 : _a[0]) === "a";
  } catch (_) {
    REGEX_SUPPORTS_U_AND_Y = false;
  }
  var startsWith = hasNativeStartsWith ? (
    // Native
    function startsWith2(s, search, position) {
      return s.startsWith(search, position);
    }
  ) : (
    // For IE11
    function startsWith2(s, search, position) {
      return s.slice(position, position + search.length) === search;
    }
  );
  var fromCodePoint = hasNativeFromCodePoint ? String.fromCodePoint : (
    // IE11
    function fromCodePoint2() {
      var codePoints = [];
      for (var _i = 0; _i < arguments.length; _i++) {
        codePoints[_i] = arguments[_i];
      }
      var elements = "";
      var length = codePoints.length;
      var i = 0;
      var code2;
      while (length > i) {
        code2 = codePoints[i++];
        if (code2 > 1114111)
          throw RangeError(code2 + " is not a valid code point");
        elements += code2 < 65536 ? String.fromCharCode(code2) : String.fromCharCode(((code2 -= 65536) >> 10) + 55296, code2 % 1024 + 56320);
      }
      return elements;
    }
  );
  var fromEntries = (
    // native
    hasNativeFromEntries ? Object.fromEntries : (
      // Ponyfill
      function fromEntries2(entries) {
        var obj = {};
        for (var _i = 0, entries_1 = entries; _i < entries_1.length; _i++) {
          var _a2 = entries_1[_i], k = _a2[0], v = _a2[1];
          obj[k] = v;
        }
        return obj;
      }
    )
  );
  var codePointAt = hasNativeCodePointAt ? (
    // Native
    function codePointAt2(s, index) {
      return s.codePointAt(index);
    }
  ) : (
    // IE 11
    function codePointAt2(s, index) {
      var size = s.length;
      if (index < 0 || index >= size) {
        return void 0;
      }
      var first = s.charCodeAt(index);
      var second;
      return first < 55296 || first > 56319 || index + 1 === size || (second = s.charCodeAt(index + 1)) < 56320 || second > 57343 ? first : (first - 55296 << 10) + (second - 56320) + 65536;
    }
  );
  var trimStart = hasTrimStart ? (
    // Native
    function trimStart2(s) {
      return s.trimStart();
    }
  ) : (
    // Ponyfill
    function trimStart2(s) {
      return s.replace(SPACE_SEPARATOR_START_REGEX, "");
    }
  );
  var trimEnd = hasTrimEnd ? (
    // Native
    function trimEnd2(s) {
      return s.trimEnd();
    }
  ) : (
    // Ponyfill
    function trimEnd2(s) {
      return s.replace(SPACE_SEPARATOR_END_REGEX, "");
    }
  );
  function RE(s, flag) {
    return new RegExp(s, flag);
  }
  var matchIdentifierAtIndex;
  if (REGEX_SUPPORTS_U_AND_Y) {
    var IDENTIFIER_PREFIX_RE_1 = RE("([^\\p{White_Space}\\p{Pattern_Syntax}]*)", "yu");
    matchIdentifierAtIndex = function matchIdentifierAtIndex2(s, index) {
      var _a2;
      IDENTIFIER_PREFIX_RE_1.lastIndex = index;
      var match = IDENTIFIER_PREFIX_RE_1.exec(s);
      return (_a2 = match[1]) !== null && _a2 !== void 0 ? _a2 : "";
    };
  } else {
    matchIdentifierAtIndex = function matchIdentifierAtIndex2(s, index) {
      var match = [];
      while (true) {
        var c = codePointAt(s, index);
        if (c === void 0 || _isWhiteSpace(c) || _isPatternSyntax(c)) {
          break;
        }
        match.push(c);
        index += c >= 65536 ? 2 : 1;
      }
      return fromCodePoint.apply(void 0, match);
    };
  }
  var Parser = (
    /** @class */
    function() {
      function Parser2(message, options) {
        if (options === void 0) {
          options = {};
        }
        this.message = message;
        this.position = { offset: 0, line: 1, column: 1 };
        this.ignoreTag = !!options.ignoreTag;
        this.locale = options.locale;
        this.requiresOtherClause = !!options.requiresOtherClause;
        this.shouldParseSkeletons = !!options.shouldParseSkeletons;
      }
      Parser2.prototype.parse = function() {
        if (this.offset() !== 0) {
          throw Error("parser can only be used once");
        }
        return this.parseMessage(0, "", false);
      };
      Parser2.prototype.parseMessage = function(nestingLevel, parentArgType, expectingCloseTag) {
        var elements = [];
        while (!this.isEOF()) {
          var char = this.char();
          if (char === 123) {
            var result = this.parseArgument(nestingLevel, expectingCloseTag);
            if (result.err) {
              return result;
            }
            elements.push(result.val);
          } else if (char === 125 && nestingLevel > 0) {
            break;
          } else if (char === 35 && (parentArgType === "plural" || parentArgType === "selectordinal")) {
            var position = this.clonePosition();
            this.bump();
            elements.push({
              type: TYPE.pound,
              location: createLocation(position, this.clonePosition())
            });
          } else if (char === 60 && !this.ignoreTag && this.peek() === 47) {
            if (expectingCloseTag) {
              break;
            } else {
              return this.error(ErrorKind.UNMATCHED_CLOSING_TAG, createLocation(this.clonePosition(), this.clonePosition()));
            }
          } else if (char === 60 && !this.ignoreTag && _isAlpha(this.peek() || 0)) {
            var result = this.parseTag(nestingLevel, parentArgType);
            if (result.err) {
              return result;
            }
            elements.push(result.val);
          } else {
            var result = this.parseLiteral(nestingLevel, parentArgType);
            if (result.err) {
              return result;
            }
            elements.push(result.val);
          }
        }
        return { val: elements, err: null };
      };
      Parser2.prototype.parseTag = function(nestingLevel, parentArgType) {
        var startPosition = this.clonePosition();
        this.bump();
        var tagName = this.parseTagName();
        this.bumpSpace();
        if (this.bumpIf("/>")) {
          return {
            val: {
              type: TYPE.literal,
              value: "<".concat(tagName, "/>"),
              location: createLocation(startPosition, this.clonePosition())
            },
            err: null
          };
        } else if (this.bumpIf(">")) {
          var childrenResult = this.parseMessage(nestingLevel + 1, parentArgType, true);
          if (childrenResult.err) {
            return childrenResult;
          }
          var children = childrenResult.val;
          var endTagStartPosition = this.clonePosition();
          if (this.bumpIf("</")) {
            if (this.isEOF() || !_isAlpha(this.char())) {
              return this.error(ErrorKind.INVALID_TAG, createLocation(endTagStartPosition, this.clonePosition()));
            }
            var closingTagNameStartPosition = this.clonePosition();
            var closingTagName = this.parseTagName();
            if (tagName !== closingTagName) {
              return this.error(ErrorKind.UNMATCHED_CLOSING_TAG, createLocation(closingTagNameStartPosition, this.clonePosition()));
            }
            this.bumpSpace();
            if (!this.bumpIf(">")) {
              return this.error(ErrorKind.INVALID_TAG, createLocation(endTagStartPosition, this.clonePosition()));
            }
            return {
              val: {
                type: TYPE.tag,
                value: tagName,
                children,
                location: createLocation(startPosition, this.clonePosition())
              },
              err: null
            };
          } else {
            return this.error(ErrorKind.UNCLOSED_TAG, createLocation(startPosition, this.clonePosition()));
          }
        } else {
          return this.error(ErrorKind.INVALID_TAG, createLocation(startPosition, this.clonePosition()));
        }
      };
      Parser2.prototype.parseTagName = function() {
        var startOffset = this.offset();
        this.bump();
        while (!this.isEOF() && _isPotentialElementNameChar(this.char())) {
          this.bump();
        }
        return this.message.slice(startOffset, this.offset());
      };
      Parser2.prototype.parseLiteral = function(nestingLevel, parentArgType) {
        var start = this.clonePosition();
        var value2 = "";
        while (true) {
          var parseQuoteResult = this.tryParseQuote(parentArgType);
          if (parseQuoteResult) {
            value2 += parseQuoteResult;
            continue;
          }
          var parseUnquotedResult = this.tryParseUnquoted(nestingLevel, parentArgType);
          if (parseUnquotedResult) {
            value2 += parseUnquotedResult;
            continue;
          }
          var parseLeftAngleResult = this.tryParseLeftAngleBracket();
          if (parseLeftAngleResult) {
            value2 += parseLeftAngleResult;
            continue;
          }
          break;
        }
        var location = createLocation(start, this.clonePosition());
        return {
          val: { type: TYPE.literal, value: value2, location },
          err: null
        };
      };
      Parser2.prototype.tryParseLeftAngleBracket = function() {
        if (!this.isEOF() && this.char() === 60 && (this.ignoreTag || // If at the opening tag or closing tag position, bail.
        !_isAlphaOrSlash(this.peek() || 0))) {
          this.bump();
          return "<";
        }
        return null;
      };
      Parser2.prototype.tryParseQuote = function(parentArgType) {
        if (this.isEOF() || this.char() !== 39) {
          return null;
        }
        switch (this.peek()) {
          case 39:
            this.bump();
            this.bump();
            return "'";
          case 123:
          case 60:
          case 62:
          case 125:
            break;
          case 35:
            if (parentArgType === "plural" || parentArgType === "selectordinal") {
              break;
            }
            return null;
          default:
            return null;
        }
        this.bump();
        var codePoints = [this.char()];
        this.bump();
        while (!this.isEOF()) {
          var ch = this.char();
          if (ch === 39) {
            if (this.peek() === 39) {
              codePoints.push(39);
              this.bump();
            } else {
              this.bump();
              break;
            }
          } else {
            codePoints.push(ch);
          }
          this.bump();
        }
        return fromCodePoint.apply(void 0, codePoints);
      };
      Parser2.prototype.tryParseUnquoted = function(nestingLevel, parentArgType) {
        if (this.isEOF()) {
          return null;
        }
        var ch = this.char();
        if (ch === 60 || ch === 123 || ch === 35 && (parentArgType === "plural" || parentArgType === "selectordinal") || ch === 125 && nestingLevel > 0) {
          return null;
        } else {
          this.bump();
          return fromCodePoint(ch);
        }
      };
      Parser2.prototype.parseArgument = function(nestingLevel, expectingCloseTag) {
        var openingBracePosition = this.clonePosition();
        this.bump();
        this.bumpSpace();
        if (this.isEOF()) {
          return this.error(ErrorKind.EXPECT_ARGUMENT_CLOSING_BRACE, createLocation(openingBracePosition, this.clonePosition()));
        }
        if (this.char() === 125) {
          this.bump();
          return this.error(ErrorKind.EMPTY_ARGUMENT, createLocation(openingBracePosition, this.clonePosition()));
        }
        var value2 = this.parseIdentifierIfPossible().value;
        if (!value2) {
          return this.error(ErrorKind.MALFORMED_ARGUMENT, createLocation(openingBracePosition, this.clonePosition()));
        }
        this.bumpSpace();
        if (this.isEOF()) {
          return this.error(ErrorKind.EXPECT_ARGUMENT_CLOSING_BRACE, createLocation(openingBracePosition, this.clonePosition()));
        }
        switch (this.char()) {
          case 125: {
            this.bump();
            return {
              val: {
                type: TYPE.argument,
                // value does not include the opening and closing braces.
                value: value2,
                location: createLocation(openingBracePosition, this.clonePosition())
              },
              err: null
            };
          }
          case 44: {
            this.bump();
            this.bumpSpace();
            if (this.isEOF()) {
              return this.error(ErrorKind.EXPECT_ARGUMENT_CLOSING_BRACE, createLocation(openingBracePosition, this.clonePosition()));
            }
            return this.parseArgumentOptions(nestingLevel, expectingCloseTag, value2, openingBracePosition);
          }
          default:
            return this.error(ErrorKind.MALFORMED_ARGUMENT, createLocation(openingBracePosition, this.clonePosition()));
        }
      };
      Parser2.prototype.parseIdentifierIfPossible = function() {
        var startingPosition = this.clonePosition();
        var startOffset = this.offset();
        var value2 = matchIdentifierAtIndex(this.message, startOffset);
        var endOffset = startOffset + value2.length;
        this.bumpTo(endOffset);
        var endPosition = this.clonePosition();
        var location = createLocation(startingPosition, endPosition);
        return { value: value2, location };
      };
      Parser2.prototype.parseArgumentOptions = function(nestingLevel, expectingCloseTag, value2, openingBracePosition) {
        var _a2;
        var typeStartPosition = this.clonePosition();
        var argType = this.parseIdentifierIfPossible().value;
        var typeEndPosition = this.clonePosition();
        switch (argType) {
          case "":
            return this.error(ErrorKind.EXPECT_ARGUMENT_TYPE, createLocation(typeStartPosition, typeEndPosition));
          case "number":
          case "date":
          case "time": {
            this.bumpSpace();
            var styleAndLocation = null;
            if (this.bumpIf(",")) {
              this.bumpSpace();
              var styleStartPosition = this.clonePosition();
              var result = this.parseSimpleArgStyleIfPossible();
              if (result.err) {
                return result;
              }
              var style = trimEnd(result.val);
              if (style.length === 0) {
                return this.error(ErrorKind.EXPECT_ARGUMENT_STYLE, createLocation(this.clonePosition(), this.clonePosition()));
              }
              var styleLocation = createLocation(styleStartPosition, this.clonePosition());
              styleAndLocation = { style, styleLocation };
            }
            var argCloseResult = this.tryParseArgumentClose(openingBracePosition);
            if (argCloseResult.err) {
              return argCloseResult;
            }
            var location_1 = createLocation(openingBracePosition, this.clonePosition());
            if (styleAndLocation && startsWith(styleAndLocation === null || styleAndLocation === void 0 ? void 0 : styleAndLocation.style, "::", 0)) {
              var skeleton = trimStart(styleAndLocation.style.slice(2));
              if (argType === "number") {
                var result = this.parseNumberSkeletonFromString(skeleton, styleAndLocation.styleLocation);
                if (result.err) {
                  return result;
                }
                return {
                  val: { type: TYPE.number, value: value2, location: location_1, style: result.val },
                  err: null
                };
              } else {
                if (skeleton.length === 0) {
                  return this.error(ErrorKind.EXPECT_DATE_TIME_SKELETON, location_1);
                }
                var dateTimePattern = skeleton;
                if (this.locale) {
                  dateTimePattern = getBestPattern(skeleton, this.locale);
                }
                var style = {
                  type: SKELETON_TYPE.dateTime,
                  pattern: dateTimePattern,
                  location: styleAndLocation.styleLocation,
                  parsedOptions: this.shouldParseSkeletons ? parseDateTimeSkeleton(dateTimePattern) : {}
                };
                var type = argType === "date" ? TYPE.date : TYPE.time;
                return {
                  val: { type, value: value2, location: location_1, style },
                  err: null
                };
              }
            }
            return {
              val: {
                type: argType === "number" ? TYPE.number : argType === "date" ? TYPE.date : TYPE.time,
                value: value2,
                location: location_1,
                style: (_a2 = styleAndLocation === null || styleAndLocation === void 0 ? void 0 : styleAndLocation.style) !== null && _a2 !== void 0 ? _a2 : null
              },
              err: null
            };
          }
          case "plural":
          case "selectordinal":
          case "select": {
            var typeEndPosition_1 = this.clonePosition();
            this.bumpSpace();
            if (!this.bumpIf(",")) {
              return this.error(ErrorKind.EXPECT_SELECT_ARGUMENT_OPTIONS, createLocation(typeEndPosition_1, __assign({}, typeEndPosition_1)));
            }
            this.bumpSpace();
            var identifierAndLocation = this.parseIdentifierIfPossible();
            var pluralOffset = 0;
            if (argType !== "select" && identifierAndLocation.value === "offset") {
              if (!this.bumpIf(":")) {
                return this.error(ErrorKind.EXPECT_PLURAL_ARGUMENT_OFFSET_VALUE, createLocation(this.clonePosition(), this.clonePosition()));
              }
              this.bumpSpace();
              var result = this.tryParseDecimalInteger(ErrorKind.EXPECT_PLURAL_ARGUMENT_OFFSET_VALUE, ErrorKind.INVALID_PLURAL_ARGUMENT_OFFSET_VALUE);
              if (result.err) {
                return result;
              }
              this.bumpSpace();
              identifierAndLocation = this.parseIdentifierIfPossible();
              pluralOffset = result.val;
            }
            var optionsResult = this.tryParsePluralOrSelectOptions(nestingLevel, argType, expectingCloseTag, identifierAndLocation);
            if (optionsResult.err) {
              return optionsResult;
            }
            var argCloseResult = this.tryParseArgumentClose(openingBracePosition);
            if (argCloseResult.err) {
              return argCloseResult;
            }
            var location_2 = createLocation(openingBracePosition, this.clonePosition());
            if (argType === "select") {
              return {
                val: {
                  type: TYPE.select,
                  value: value2,
                  options: fromEntries(optionsResult.val),
                  location: location_2
                },
                err: null
              };
            } else {
              return {
                val: {
                  type: TYPE.plural,
                  value: value2,
                  options: fromEntries(optionsResult.val),
                  offset: pluralOffset,
                  pluralType: argType === "plural" ? "cardinal" : "ordinal",
                  location: location_2
                },
                err: null
              };
            }
          }
          default:
            return this.error(ErrorKind.INVALID_ARGUMENT_TYPE, createLocation(typeStartPosition, typeEndPosition));
        }
      };
      Parser2.prototype.tryParseArgumentClose = function(openingBracePosition) {
        if (this.isEOF() || this.char() !== 125) {
          return this.error(ErrorKind.EXPECT_ARGUMENT_CLOSING_BRACE, createLocation(openingBracePosition, this.clonePosition()));
        }
        this.bump();
        return { val: true, err: null };
      };
      Parser2.prototype.parseSimpleArgStyleIfPossible = function() {
        var nestedBraces = 0;
        var startPosition = this.clonePosition();
        while (!this.isEOF()) {
          var ch = this.char();
          switch (ch) {
            case 39: {
              this.bump();
              var apostrophePosition = this.clonePosition();
              if (!this.bumpUntil("'")) {
                return this.error(ErrorKind.UNCLOSED_QUOTE_IN_ARGUMENT_STYLE, createLocation(apostrophePosition, this.clonePosition()));
              }
              this.bump();
              break;
            }
            case 123: {
              nestedBraces += 1;
              this.bump();
              break;
            }
            case 125: {
              if (nestedBraces > 0) {
                nestedBraces -= 1;
              } else {
                return {
                  val: this.message.slice(startPosition.offset, this.offset()),
                  err: null
                };
              }
              break;
            }
            default:
              this.bump();
              break;
          }
        }
        return {
          val: this.message.slice(startPosition.offset, this.offset()),
          err: null
        };
      };
      Parser2.prototype.parseNumberSkeletonFromString = function(skeleton, location) {
        var tokens = [];
        try {
          tokens = parseNumberSkeletonFromString(skeleton);
        } catch (e) {
          return this.error(ErrorKind.INVALID_NUMBER_SKELETON, location);
        }
        return {
          val: {
            type: SKELETON_TYPE.number,
            tokens,
            location,
            parsedOptions: this.shouldParseSkeletons ? parseNumberSkeleton(tokens) : {}
          },
          err: null
        };
      };
      Parser2.prototype.tryParsePluralOrSelectOptions = function(nestingLevel, parentArgType, expectCloseTag, parsedFirstIdentifier) {
        var _a2;
        var hasOtherClause = false;
        var options = [];
        var parsedSelectors = /* @__PURE__ */ new Set();
        var selector = parsedFirstIdentifier.value, selectorLocation = parsedFirstIdentifier.location;
        while (true) {
          if (selector.length === 0) {
            var startPosition = this.clonePosition();
            if (parentArgType !== "select" && this.bumpIf("=")) {
              var result = this.tryParseDecimalInteger(ErrorKind.EXPECT_PLURAL_ARGUMENT_SELECTOR, ErrorKind.INVALID_PLURAL_ARGUMENT_SELECTOR);
              if (result.err) {
                return result;
              }
              selectorLocation = createLocation(startPosition, this.clonePosition());
              selector = this.message.slice(startPosition.offset, this.offset());
            } else {
              break;
            }
          }
          if (parsedSelectors.has(selector)) {
            return this.error(parentArgType === "select" ? ErrorKind.DUPLICATE_SELECT_ARGUMENT_SELECTOR : ErrorKind.DUPLICATE_PLURAL_ARGUMENT_SELECTOR, selectorLocation);
          }
          if (selector === "other") {
            hasOtherClause = true;
          }
          this.bumpSpace();
          var openingBracePosition = this.clonePosition();
          if (!this.bumpIf("{")) {
            return this.error(parentArgType === "select" ? ErrorKind.EXPECT_SELECT_ARGUMENT_SELECTOR_FRAGMENT : ErrorKind.EXPECT_PLURAL_ARGUMENT_SELECTOR_FRAGMENT, createLocation(this.clonePosition(), this.clonePosition()));
          }
          var fragmentResult = this.parseMessage(nestingLevel + 1, parentArgType, expectCloseTag);
          if (fragmentResult.err) {
            return fragmentResult;
          }
          var argCloseResult = this.tryParseArgumentClose(openingBracePosition);
          if (argCloseResult.err) {
            return argCloseResult;
          }
          options.push([
            selector,
            {
              value: fragmentResult.val,
              location: createLocation(openingBracePosition, this.clonePosition())
            }
          ]);
          parsedSelectors.add(selector);
          this.bumpSpace();
          _a2 = this.parseIdentifierIfPossible(), selector = _a2.value, selectorLocation = _a2.location;
        }
        if (options.length === 0) {
          return this.error(parentArgType === "select" ? ErrorKind.EXPECT_SELECT_ARGUMENT_SELECTOR : ErrorKind.EXPECT_PLURAL_ARGUMENT_SELECTOR, createLocation(this.clonePosition(), this.clonePosition()));
        }
        if (this.requiresOtherClause && !hasOtherClause) {
          return this.error(ErrorKind.MISSING_OTHER_CLAUSE, createLocation(this.clonePosition(), this.clonePosition()));
        }
        return { val: options, err: null };
      };
      Parser2.prototype.tryParseDecimalInteger = function(expectNumberError, invalidNumberError) {
        var sign = 1;
        var startingPosition = this.clonePosition();
        if (this.bumpIf("+")) ;
        else if (this.bumpIf("-")) {
          sign = -1;
        }
        var hasDigits = false;
        var decimal2 = 0;
        while (!this.isEOF()) {
          var ch = this.char();
          if (ch >= 48 && ch <= 57) {
            hasDigits = true;
            decimal2 = decimal2 * 10 + (ch - 48);
            this.bump();
          } else {
            break;
          }
        }
        var location = createLocation(startingPosition, this.clonePosition());
        if (!hasDigits) {
          return this.error(expectNumberError, location);
        }
        decimal2 *= sign;
        if (!isSafeInteger(decimal2)) {
          return this.error(invalidNumberError, location);
        }
        return { val: decimal2, err: null };
      };
      Parser2.prototype.offset = function() {
        return this.position.offset;
      };
      Parser2.prototype.isEOF = function() {
        return this.offset() === this.message.length;
      };
      Parser2.prototype.clonePosition = function() {
        return {
          offset: this.position.offset,
          line: this.position.line,
          column: this.position.column
        };
      };
      Parser2.prototype.char = function() {
        var offset = this.position.offset;
        if (offset >= this.message.length) {
          throw Error("out of bound");
        }
        var code2 = codePointAt(this.message, offset);
        if (code2 === void 0) {
          throw Error("Offset ".concat(offset, " is at invalid UTF-16 code unit boundary"));
        }
        return code2;
      };
      Parser2.prototype.error = function(kind, location) {
        return {
          val: null,
          err: {
            kind,
            message: this.message,
            location
          }
        };
      };
      Parser2.prototype.bump = function() {
        if (this.isEOF()) {
          return;
        }
        var code2 = this.char();
        if (code2 === 10) {
          this.position.line += 1;
          this.position.column = 1;
          this.position.offset += 1;
        } else {
          this.position.column += 1;
          this.position.offset += code2 < 65536 ? 1 : 2;
        }
      };
      Parser2.prototype.bumpIf = function(prefix) {
        if (startsWith(this.message, prefix, this.offset())) {
          for (var i = 0; i < prefix.length; i++) {
            this.bump();
          }
          return true;
        }
        return false;
      };
      Parser2.prototype.bumpUntil = function(pattern) {
        var currentOffset = this.offset();
        var index = this.message.indexOf(pattern, currentOffset);
        if (index >= 0) {
          this.bumpTo(index);
          return true;
        } else {
          this.bumpTo(this.message.length);
          return false;
        }
      };
      Parser2.prototype.bumpTo = function(targetOffset) {
        if (this.offset() > targetOffset) {
          throw Error("targetOffset ".concat(targetOffset, " must be greater than or equal to the current offset ").concat(this.offset()));
        }
        targetOffset = Math.min(targetOffset, this.message.length);
        while (true) {
          var offset = this.offset();
          if (offset === targetOffset) {
            break;
          }
          if (offset > targetOffset) {
            throw Error("targetOffset ".concat(targetOffset, " is at invalid UTF-16 code unit boundary"));
          }
          this.bump();
          if (this.isEOF()) {
            break;
          }
        }
      };
      Parser2.prototype.bumpSpace = function() {
        while (!this.isEOF() && _isWhiteSpace(this.char())) {
          this.bump();
        }
      };
      Parser2.prototype.peek = function() {
        if (this.isEOF()) {
          return null;
        }
        var code2 = this.char();
        var offset = this.offset();
        var nextCode = this.message.charCodeAt(offset + (code2 >= 65536 ? 2 : 1));
        return nextCode !== null && nextCode !== void 0 ? nextCode : null;
      };
      return Parser2;
    }()
  );
  function _isAlpha(codepoint) {
    return codepoint >= 97 && codepoint <= 122 || codepoint >= 65 && codepoint <= 90;
  }
  function _isAlphaOrSlash(codepoint) {
    return _isAlpha(codepoint) || codepoint === 47;
  }
  function _isPotentialElementNameChar(c) {
    return c === 45 || c === 46 || c >= 48 && c <= 57 || c === 95 || c >= 97 && c <= 122 || c >= 65 && c <= 90 || c == 183 || c >= 192 && c <= 214 || c >= 216 && c <= 246 || c >= 248 && c <= 893 || c >= 895 && c <= 8191 || c >= 8204 && c <= 8205 || c >= 8255 && c <= 8256 || c >= 8304 && c <= 8591 || c >= 11264 && c <= 12271 || c >= 12289 && c <= 55295 || c >= 63744 && c <= 64975 || c >= 65008 && c <= 65533 || c >= 65536 && c <= 983039;
  }
  function _isWhiteSpace(c) {
    return c >= 9 && c <= 13 || c === 32 || c === 133 || c >= 8206 && c <= 8207 || c === 8232 || c === 8233;
  }
  function _isPatternSyntax(c) {
    return c >= 33 && c <= 35 || c === 36 || c >= 37 && c <= 39 || c === 40 || c === 41 || c === 42 || c === 43 || c === 44 || c === 45 || c >= 46 && c <= 47 || c >= 58 && c <= 59 || c >= 60 && c <= 62 || c >= 63 && c <= 64 || c === 91 || c === 92 || c === 93 || c === 94 || c === 96 || c === 123 || c === 124 || c === 125 || c === 126 || c === 161 || c >= 162 && c <= 165 || c === 166 || c === 167 || c === 169 || c === 171 || c === 172 || c === 174 || c === 176 || c === 177 || c === 182 || c === 187 || c === 191 || c === 215 || c === 247 || c >= 8208 && c <= 8213 || c >= 8214 && c <= 8215 || c === 8216 || c === 8217 || c === 8218 || c >= 8219 && c <= 8220 || c === 8221 || c === 8222 || c === 8223 || c >= 8224 && c <= 8231 || c >= 8240 && c <= 8248 || c === 8249 || c === 8250 || c >= 8251 && c <= 8254 || c >= 8257 && c <= 8259 || c === 8260 || c === 8261 || c === 8262 || c >= 8263 && c <= 8273 || c === 8274 || c === 8275 || c >= 8277 && c <= 8286 || c >= 8592 && c <= 8596 || c >= 8597 && c <= 8601 || c >= 8602 && c <= 8603 || c >= 8604 && c <= 8607 || c === 8608 || c >= 8609 && c <= 8610 || c === 8611 || c >= 8612 && c <= 8613 || c === 8614 || c >= 8615 && c <= 8621 || c === 8622 || c >= 8623 && c <= 8653 || c >= 8654 && c <= 8655 || c >= 8656 && c <= 8657 || c === 8658 || c === 8659 || c === 8660 || c >= 8661 && c <= 8691 || c >= 8692 && c <= 8959 || c >= 8960 && c <= 8967 || c === 8968 || c === 8969 || c === 8970 || c === 8971 || c >= 8972 && c <= 8991 || c >= 8992 && c <= 8993 || c >= 8994 && c <= 9e3 || c === 9001 || c === 9002 || c >= 9003 && c <= 9083 || c === 9084 || c >= 9085 && c <= 9114 || c >= 9115 && c <= 9139 || c >= 9140 && c <= 9179 || c >= 9180 && c <= 9185 || c >= 9186 && c <= 9254 || c >= 9255 && c <= 9279 || c >= 9280 && c <= 9290 || c >= 9291 && c <= 9311 || c >= 9472 && c <= 9654 || c === 9655 || c >= 9656 && c <= 9664 || c === 9665 || c >= 9666 && c <= 9719 || c >= 9720 && c <= 9727 || c >= 9728 && c <= 9838 || c === 9839 || c >= 9840 && c <= 10087 || c === 10088 || c === 10089 || c === 10090 || c === 10091 || c === 10092 || c === 10093 || c === 10094 || c === 10095 || c === 10096 || c === 10097 || c === 10098 || c === 10099 || c === 10100 || c === 10101 || c >= 10132 && c <= 10175 || c >= 10176 && c <= 10180 || c === 10181 || c === 10182 || c >= 10183 && c <= 10213 || c === 10214 || c === 10215 || c === 10216 || c === 10217 || c === 10218 || c === 10219 || c === 10220 || c === 10221 || c === 10222 || c === 10223 || c >= 10224 && c <= 10239 || c >= 10240 && c <= 10495 || c >= 10496 && c <= 10626 || c === 10627 || c === 10628 || c === 10629 || c === 10630 || c === 10631 || c === 10632 || c === 10633 || c === 10634 || c === 10635 || c === 10636 || c === 10637 || c === 10638 || c === 10639 || c === 10640 || c === 10641 || c === 10642 || c === 10643 || c === 10644 || c === 10645 || c === 10646 || c === 10647 || c === 10648 || c >= 10649 && c <= 10711 || c === 10712 || c === 10713 || c === 10714 || c === 10715 || c >= 10716 && c <= 10747 || c === 10748 || c === 10749 || c >= 10750 && c <= 11007 || c >= 11008 && c <= 11055 || c >= 11056 && c <= 11076 || c >= 11077 && c <= 11078 || c >= 11079 && c <= 11084 || c >= 11085 && c <= 11123 || c >= 11124 && c <= 11125 || c >= 11126 && c <= 11157 || c === 11158 || c >= 11159 && c <= 11263 || c >= 11776 && c <= 11777 || c === 11778 || c === 11779 || c === 11780 || c === 11781 || c >= 11782 && c <= 11784 || c === 11785 || c === 11786 || c === 11787 || c === 11788 || c === 11789 || c >= 11790 && c <= 11798 || c === 11799 || c >= 11800 && c <= 11801 || c === 11802 || c === 11803 || c === 11804 || c === 11805 || c >= 11806 && c <= 11807 || c === 11808 || c === 11809 || c === 11810 || c === 11811 || c === 11812 || c === 11813 || c === 11814 || c === 11815 || c === 11816 || c === 11817 || c >= 11818 && c <= 11822 || c === 11823 || c >= 11824 && c <= 11833 || c >= 11834 && c <= 11835 || c >= 11836 && c <= 11839 || c === 11840 || c === 11841 || c === 11842 || c >= 11843 && c <= 11855 || c >= 11856 && c <= 11857 || c === 11858 || c >= 11859 && c <= 11903 || c >= 12289 && c <= 12291 || c === 12296 || c === 12297 || c === 12298 || c === 12299 || c === 12300 || c === 12301 || c === 12302 || c === 12303 || c === 12304 || c === 12305 || c >= 12306 && c <= 12307 || c === 12308 || c === 12309 || c === 12310 || c === 12311 || c === 12312 || c === 12313 || c === 12314 || c === 12315 || c === 12316 || c === 12317 || c >= 12318 && c <= 12319 || c === 12320 || c === 12336 || c === 64830 || c === 64831 || c >= 65093 && c <= 65094;
  }
  function pruneLocation(els) {
    els.forEach(function(el) {
      delete el.location;
      if (isSelectElement(el) || isPluralElement(el)) {
        for (var k in el.options) {
          delete el.options[k].location;
          pruneLocation(el.options[k].value);
        }
      } else if (isNumberElement(el) && isNumberSkeleton(el.style)) {
        delete el.style.location;
      } else if ((isDateElement(el) || isTimeElement(el)) && isDateTimeSkeleton(el.style)) {
        delete el.style.location;
      } else if (isTagElement(el)) {
        pruneLocation(el.children);
      }
    });
  }
  function parse(message, opts) {
    if (opts === void 0) {
      opts = {};
    }
    opts = __assign({ shouldParseSkeletons: true, requiresOtherClause: true }, opts);
    var result = new Parser(message, opts).parse();
    if (result.err) {
      var error = SyntaxError(ErrorKind[result.err.kind]);
      error.location = result.err.location;
      error.originalMessage = result.err.message;
      throw error;
    }
    if (!(opts === null || opts === void 0 ? void 0 : opts.captureLocation)) {
      pruneLocation(result.val);
    }
    return result.val;
  }
  var ErrorCode;
  (function(ErrorCode2) {
    ErrorCode2["MISSING_VALUE"] = "MISSING_VALUE";
    ErrorCode2["INVALID_VALUE"] = "INVALID_VALUE";
    ErrorCode2["MISSING_INTL_API"] = "MISSING_INTL_API";
  })(ErrorCode || (ErrorCode = {}));
  var FormatError = (
    /** @class */
    function(_super) {
      __extends(FormatError2, _super);
      function FormatError2(msg, code2, originalMessage) {
        var _this = _super.call(this, msg) || this;
        _this.code = code2;
        _this.originalMessage = originalMessage;
        return _this;
      }
      FormatError2.prototype.toString = function() {
        return "[formatjs Error: ".concat(this.code, "] ").concat(this.message);
      };
      return FormatError2;
    }(Error)
  );
  var InvalidValueError = (
    /** @class */
    function(_super) {
      __extends(InvalidValueError2, _super);
      function InvalidValueError2(variableId, value2, options, originalMessage) {
        return _super.call(this, 'Invalid values for "'.concat(variableId, '": "').concat(value2, '". Options are "').concat(Object.keys(options).join('", "'), '"'), ErrorCode.INVALID_VALUE, originalMessage) || this;
      }
      return InvalidValueError2;
    }(FormatError)
  );
  var InvalidValueTypeError = (
    /** @class */
    function(_super) {
      __extends(InvalidValueTypeError2, _super);
      function InvalidValueTypeError2(value2, type, originalMessage) {
        return _super.call(this, 'Value for "'.concat(value2, '" must be of type ').concat(type), ErrorCode.INVALID_VALUE, originalMessage) || this;
      }
      return InvalidValueTypeError2;
    }(FormatError)
  );
  var MissingValueError = (
    /** @class */
    function(_super) {
      __extends(MissingValueError2, _super);
      function MissingValueError2(variableId, originalMessage) {
        return _super.call(this, 'The intl string context variable "'.concat(variableId, '" was not provided to the string "').concat(originalMessage, '"'), ErrorCode.MISSING_VALUE, originalMessage) || this;
      }
      return MissingValueError2;
    }(FormatError)
  );
  var PART_TYPE;
  (function(PART_TYPE2) {
    PART_TYPE2[PART_TYPE2["literal"] = 0] = "literal";
    PART_TYPE2[PART_TYPE2["object"] = 1] = "object";
  })(PART_TYPE || (PART_TYPE = {}));
  function mergeLiteral(parts) {
    if (parts.length < 2) {
      return parts;
    }
    return parts.reduce(function(all, part) {
      var lastPart = all[all.length - 1];
      if (!lastPart || lastPart.type !== PART_TYPE.literal || part.type !== PART_TYPE.literal) {
        all.push(part);
      } else {
        lastPart.value += part.value;
      }
      return all;
    }, []);
  }
  function isFormatXMLElementFn(el) {
    return typeof el === "function";
  }
  function formatToParts(els, locales, formatters, formats, values, currentPluralValue, originalMessage) {
    if (els.length === 1 && isLiteralElement(els[0])) {
      return [
        {
          type: PART_TYPE.literal,
          value: els[0].value
        }
      ];
    }
    var result = [];
    for (var _i = 0, els_1 = els; _i < els_1.length; _i++) {
      var el = els_1[_i];
      if (isLiteralElement(el)) {
        result.push({
          type: PART_TYPE.literal,
          value: el.value
        });
        continue;
      }
      if (isPoundElement(el)) {
        if (typeof currentPluralValue === "number") {
          result.push({
            type: PART_TYPE.literal,
            value: formatters.getNumberFormat(locales).format(currentPluralValue)
          });
        }
        continue;
      }
      var varName = el.value;
      if (!(values && varName in values)) {
        throw new MissingValueError(varName, originalMessage);
      }
      var value2 = values[varName];
      if (isArgumentElement(el)) {
        if (!value2 || typeof value2 === "string" || typeof value2 === "number") {
          value2 = typeof value2 === "string" || typeof value2 === "number" ? String(value2) : "";
        }
        result.push({
          type: typeof value2 === "string" ? PART_TYPE.literal : PART_TYPE.object,
          value: value2
        });
        continue;
      }
      if (isDateElement(el)) {
        var style = typeof el.style === "string" ? formats.date[el.style] : isDateTimeSkeleton(el.style) ? el.style.parsedOptions : void 0;
        result.push({
          type: PART_TYPE.literal,
          value: formatters.getDateTimeFormat(locales, style).format(value2)
        });
        continue;
      }
      if (isTimeElement(el)) {
        var style = typeof el.style === "string" ? formats.time[el.style] : isDateTimeSkeleton(el.style) ? el.style.parsedOptions : formats.time.medium;
        result.push({
          type: PART_TYPE.literal,
          value: formatters.getDateTimeFormat(locales, style).format(value2)
        });
        continue;
      }
      if (isNumberElement(el)) {
        var style = typeof el.style === "string" ? formats.number[el.style] : isNumberSkeleton(el.style) ? el.style.parsedOptions : void 0;
        if (style && style.scale) {
          value2 = value2 * (style.scale || 1);
        }
        result.push({
          type: PART_TYPE.literal,
          value: formatters.getNumberFormat(locales, style).format(value2)
        });
        continue;
      }
      if (isTagElement(el)) {
        var children = el.children, value_1 = el.value;
        var formatFn = values[value_1];
        if (!isFormatXMLElementFn(formatFn)) {
          throw new InvalidValueTypeError(value_1, "function", originalMessage);
        }
        var parts = formatToParts(children, locales, formatters, formats, values, currentPluralValue);
        var chunks = formatFn(parts.map(function(p) {
          return p.value;
        }));
        if (!Array.isArray(chunks)) {
          chunks = [chunks];
        }
        result.push.apply(result, chunks.map(function(c) {
          return {
            type: typeof c === "string" ? PART_TYPE.literal : PART_TYPE.object,
            value: c
          };
        }));
      }
      if (isSelectElement(el)) {
        var opt = el.options[value2] || el.options.other;
        if (!opt) {
          throw new InvalidValueError(el.value, value2, Object.keys(el.options), originalMessage);
        }
        result.push.apply(result, formatToParts(opt.value, locales, formatters, formats, values));
        continue;
      }
      if (isPluralElement(el)) {
        var opt = el.options["=".concat(value2)];
        if (!opt) {
          if (!Intl.PluralRules) {
            throw new FormatError('Intl.PluralRules is not available in this environment.\nTry polyfilling it using "@formatjs/intl-pluralrules"\n', ErrorCode.MISSING_INTL_API, originalMessage);
          }
          var rule = formatters.getPluralRules(locales, { type: el.pluralType }).select(value2 - (el.offset || 0));
          opt = el.options[rule] || el.options.other;
        }
        if (!opt) {
          throw new InvalidValueError(el.value, value2, Object.keys(el.options), originalMessage);
        }
        result.push.apply(result, formatToParts(opt.value, locales, formatters, formats, values, value2 - (el.offset || 0)));
        continue;
      }
    }
    return mergeLiteral(result);
  }
  function mergeConfig(c1, c2) {
    if (!c2) {
      return c1;
    }
    return __assign(__assign(__assign({}, c1 || {}), c2 || {}), Object.keys(c1).reduce(function(all, k) {
      all[k] = __assign(__assign({}, c1[k]), c2[k] || {});
      return all;
    }, {}));
  }
  function mergeConfigs(defaultConfig, configs) {
    if (!configs) {
      return defaultConfig;
    }
    return Object.keys(defaultConfig).reduce(function(all, k) {
      all[k] = mergeConfig(defaultConfig[k], configs[k]);
      return all;
    }, __assign({}, defaultConfig));
  }
  function createFastMemoizeCache$1(store) {
    return {
      create: function() {
        return {
          get: function(key) {
            return store[key];
          },
          set: function(key, value2) {
            store[key] = value2;
          }
        };
      }
    };
  }
  function createDefaultFormatters(cache) {
    if (cache === void 0) {
      cache = {
        number: {},
        dateTime: {},
        pluralRules: {}
      };
    }
    return {
      getNumberFormat: memoize(function() {
        var _a2;
        var args = [];
        for (var _i = 0; _i < arguments.length; _i++) {
          args[_i] = arguments[_i];
        }
        return new ((_a2 = Intl.NumberFormat).bind.apply(_a2, __spreadArray([void 0], args, false)))();
      }, {
        cache: createFastMemoizeCache$1(cache.number),
        strategy: strategies.variadic
      }),
      getDateTimeFormat: memoize(function() {
        var _a2;
        var args = [];
        for (var _i = 0; _i < arguments.length; _i++) {
          args[_i] = arguments[_i];
        }
        return new ((_a2 = Intl.DateTimeFormat).bind.apply(_a2, __spreadArray([void 0], args, false)))();
      }, {
        cache: createFastMemoizeCache$1(cache.dateTime),
        strategy: strategies.variadic
      }),
      getPluralRules: memoize(function() {
        var _a2;
        var args = [];
        for (var _i = 0; _i < arguments.length; _i++) {
          args[_i] = arguments[_i];
        }
        return new ((_a2 = Intl.PluralRules).bind.apply(_a2, __spreadArray([void 0], args, false)))();
      }, {
        cache: createFastMemoizeCache$1(cache.pluralRules),
        strategy: strategies.variadic
      })
    };
  }
  var IntlMessageFormat = (
    /** @class */
    function() {
      function IntlMessageFormat2(message, locales, overrideFormats, opts) {
        if (locales === void 0) {
          locales = IntlMessageFormat2.defaultLocale;
        }
        var _this = this;
        this.formatterCache = {
          number: {},
          dateTime: {},
          pluralRules: {}
        };
        this.format = function(values) {
          var parts = _this.formatToParts(values);
          if (parts.length === 1) {
            return parts[0].value;
          }
          var result = parts.reduce(function(all, part) {
            if (!all.length || part.type !== PART_TYPE.literal || typeof all[all.length - 1] !== "string") {
              all.push(part.value);
            } else {
              all[all.length - 1] += part.value;
            }
            return all;
          }, []);
          if (result.length <= 1) {
            return result[0] || "";
          }
          return result;
        };
        this.formatToParts = function(values) {
          return formatToParts(_this.ast, _this.locales, _this.formatters, _this.formats, values, void 0, _this.message);
        };
        this.resolvedOptions = function() {
          var _a3;
          return {
            locale: ((_a3 = _this.resolvedLocale) === null || _a3 === void 0 ? void 0 : _a3.toString()) || Intl.NumberFormat.supportedLocalesOf(_this.locales)[0]
          };
        };
        this.getAst = function() {
          return _this.ast;
        };
        this.locales = locales;
        this.resolvedLocale = IntlMessageFormat2.resolveLocale(locales);
        if (typeof message === "string") {
          this.message = message;
          if (!IntlMessageFormat2.__parse) {
            throw new TypeError("IntlMessageFormat.__parse must be set to process `message` of type `string`");
          }
          var _a2 = opts || {};
          _a2.formatters;
          var parseOpts = __rest(_a2, ["formatters"]);
          this.ast = IntlMessageFormat2.__parse(message, __assign(__assign({}, parseOpts), { locale: this.resolvedLocale }));
        } else {
          this.ast = message;
        }
        if (!Array.isArray(this.ast)) {
          throw new TypeError("A message must be provided as a String or AST.");
        }
        this.formats = mergeConfigs(IntlMessageFormat2.formats, overrideFormats);
        this.formatters = opts && opts.formatters || createDefaultFormatters(this.formatterCache);
      }
      Object.defineProperty(IntlMessageFormat2, "defaultLocale", {
        get: function() {
          if (!IntlMessageFormat2.memoizedDefaultLocale) {
            IntlMessageFormat2.memoizedDefaultLocale = new Intl.NumberFormat().resolvedOptions().locale;
          }
          return IntlMessageFormat2.memoizedDefaultLocale;
        },
        enumerable: false,
        configurable: true
      });
      IntlMessageFormat2.memoizedDefaultLocale = null;
      IntlMessageFormat2.resolveLocale = function(locales) {
        if (typeof Intl.Locale === "undefined") {
          return;
        }
        var supportedLocales = Intl.NumberFormat.supportedLocalesOf(locales);
        if (supportedLocales.length > 0) {
          return new Intl.Locale(supportedLocales[0]);
        }
        return new Intl.Locale(typeof locales === "string" ? locales : locales[0]);
      };
      IntlMessageFormat2.__parse = parse;
      IntlMessageFormat2.formats = {
        number: {
          integer: {
            maximumFractionDigits: 0
          },
          currency: {
            style: "currency"
          },
          percent: {
            style: "percent"
          }
        },
        date: {
          short: {
            month: "numeric",
            day: "numeric",
            year: "2-digit"
          },
          medium: {
            month: "short",
            day: "numeric",
            year: "numeric"
          },
          long: {
            month: "long",
            day: "numeric",
            year: "numeric"
          },
          full: {
            weekday: "long",
            month: "long",
            day: "numeric",
            year: "numeric"
          }
        },
        time: {
          short: {
            hour: "numeric",
            minute: "numeric"
          },
          medium: {
            hour: "numeric",
            minute: "numeric",
            second: "numeric"
          },
          long: {
            hour: "numeric",
            minute: "numeric",
            second: "numeric",
            timeZoneName: "short"
          },
          full: {
            hour: "numeric",
            minute: "numeric",
            second: "numeric",
            timeZoneName: "short"
          }
        }
      };
      return IntlMessageFormat2;
    }()
  );
  var IntlErrorCode;
  (function(IntlErrorCode2) {
    IntlErrorCode2["FORMAT_ERROR"] = "FORMAT_ERROR";
    IntlErrorCode2["UNSUPPORTED_FORMATTER"] = "UNSUPPORTED_FORMATTER";
    IntlErrorCode2["INVALID_CONFIG"] = "INVALID_CONFIG";
    IntlErrorCode2["MISSING_DATA"] = "MISSING_DATA";
    IntlErrorCode2["MISSING_TRANSLATION"] = "MISSING_TRANSLATION";
  })(IntlErrorCode || (IntlErrorCode = {}));
  var IntlError = (
    /** @class */
    function(_super) {
      __extends(IntlError2, _super);
      function IntlError2(code2, message, exception) {
        var _this = this;
        var err = exception ? exception instanceof Error ? exception : new Error(String(exception)) : void 0;
        _this = _super.call(this, "[@formatjs/intl Error ".concat(code2, "] ").concat(message, "\n").concat(err ? "\n".concat(err.message, "\n").concat(err.stack) : "")) || this;
        _this.code = code2;
        if (typeof Error.captureStackTrace === "function") {
          Error.captureStackTrace(_this, IntlError2);
        }
        return _this;
      }
      return IntlError2;
    }(Error)
  );
  var UnsupportedFormatterError = (
    /** @class */
    function(_super) {
      __extends(UnsupportedFormatterError2, _super);
      function UnsupportedFormatterError2(message, exception) {
        return _super.call(this, IntlErrorCode.UNSUPPORTED_FORMATTER, message, exception) || this;
      }
      return UnsupportedFormatterError2;
    }(IntlError)
  );
  var InvalidConfigError = (
    /** @class */
    function(_super) {
      __extends(InvalidConfigError2, _super);
      function InvalidConfigError2(message, exception) {
        return _super.call(this, IntlErrorCode.INVALID_CONFIG, message, exception) || this;
      }
      return InvalidConfigError2;
    }(IntlError)
  );
  var MissingDataError = (
    /** @class */
    function(_super) {
      __extends(MissingDataError2, _super);
      function MissingDataError2(message, exception) {
        return _super.call(this, IntlErrorCode.MISSING_DATA, message, exception) || this;
      }
      return MissingDataError2;
    }(IntlError)
  );
  var IntlFormatError = (
    /** @class */
    function(_super) {
      __extends(IntlFormatError2, _super);
      function IntlFormatError2(message, locale, exception) {
        var _this = _super.call(this, IntlErrorCode.FORMAT_ERROR, "".concat(message, "\nLocale: ").concat(locale, "\n"), exception) || this;
        _this.locale = locale;
        return _this;
      }
      return IntlFormatError2;
    }(IntlError)
  );
  var MessageFormatError = (
    /** @class */
    function(_super) {
      __extends(MessageFormatError2, _super);
      function MessageFormatError2(message, locale, descriptor, exception) {
        var _this = _super.call(this, "".concat(message, "\nMessageID: ").concat(descriptor === null || descriptor === void 0 ? void 0 : descriptor.id, "\nDefault Message: ").concat(descriptor === null || descriptor === void 0 ? void 0 : descriptor.defaultMessage, "\nDescription: ").concat(descriptor === null || descriptor === void 0 ? void 0 : descriptor.description, "\n"), locale, exception) || this;
        _this.descriptor = descriptor;
        _this.locale = locale;
        return _this;
      }
      return MessageFormatError2;
    }(IntlFormatError)
  );
  var MissingTranslationError = (
    /** @class */
    function(_super) {
      __extends(MissingTranslationError2, _super);
      function MissingTranslationError2(descriptor, locale) {
        var _this = _super.call(this, IntlErrorCode.MISSING_TRANSLATION, 'Missing message: "'.concat(descriptor.id, '" for locale "').concat(locale, '", using ').concat(descriptor.defaultMessage ? "default message (".concat(typeof descriptor.defaultMessage === "string" ? descriptor.defaultMessage : descriptor.defaultMessage.map(function(e) {
          var _a2;
          return (_a2 = e.value) !== null && _a2 !== void 0 ? _a2 : JSON.stringify(e);
        }).join(), ")") : "id", " as fallback.")) || this;
        _this.descriptor = descriptor;
        return _this;
      }
      return MissingTranslationError2;
    }(IntlError)
  );
  function invariant(condition, message, Err) {
    if (Err === void 0) {
      Err = Error;
    }
    if (!condition) {
      throw new Err(message);
    }
  }
  function filterProps(props, allowlist, defaults) {
    if (defaults === void 0) {
      defaults = {};
    }
    return allowlist.reduce(function(filtered, name) {
      if (name in props) {
        filtered[name] = props[name];
      } else if (name in defaults) {
        filtered[name] = defaults[name];
      }
      return filtered;
    }, {});
  }
  var defaultErrorHandler = function(error) {
    if (process.env.NODE_ENV !== "production") {
      console.error(error);
    }
  };
  var defaultWarnHandler = function(warning) {
    if (process.env.NODE_ENV !== "production") {
      console.warn(warning);
    }
  };
  var DEFAULT_INTL_CONFIG = {
    formats: {},
    messages: {},
    timeZone: void 0,
    defaultLocale: "en",
    defaultFormats: {},
    fallbackOnEmptyString: true,
    onError: defaultErrorHandler,
    onWarn: defaultWarnHandler
  };
  function createIntlCache() {
    return {
      dateTime: {},
      number: {},
      message: {},
      relativeTime: {},
      pluralRules: {},
      list: {},
      displayNames: {}
    };
  }
  function createFastMemoizeCache(store) {
    return {
      create: function() {
        return {
          get: function(key) {
            return store[key];
          },
          set: function(key, value2) {
            store[key] = value2;
          }
        };
      }
    };
  }
  function createFormatters(cache) {
    if (cache === void 0) {
      cache = createIntlCache();
    }
    var RelativeTimeFormat = Intl.RelativeTimeFormat;
    var ListFormat = Intl.ListFormat;
    var DisplayNames = Intl.DisplayNames;
    var getDateTimeFormat = memoize(function() {
      var _a2;
      var args = [];
      for (var _i = 0; _i < arguments.length; _i++) {
        args[_i] = arguments[_i];
      }
      return new ((_a2 = Intl.DateTimeFormat).bind.apply(_a2, __spreadArray([void 0], args, false)))();
    }, {
      cache: createFastMemoizeCache(cache.dateTime),
      strategy: strategies.variadic
    });
    var getNumberFormat = memoize(function() {
      var _a2;
      var args = [];
      for (var _i = 0; _i < arguments.length; _i++) {
        args[_i] = arguments[_i];
      }
      return new ((_a2 = Intl.NumberFormat).bind.apply(_a2, __spreadArray([void 0], args, false)))();
    }, {
      cache: createFastMemoizeCache(cache.number),
      strategy: strategies.variadic
    });
    var getPluralRules = memoize(function() {
      var _a2;
      var args = [];
      for (var _i = 0; _i < arguments.length; _i++) {
        args[_i] = arguments[_i];
      }
      return new ((_a2 = Intl.PluralRules).bind.apply(_a2, __spreadArray([void 0], args, false)))();
    }, {
      cache: createFastMemoizeCache(cache.pluralRules),
      strategy: strategies.variadic
    });
    return {
      getDateTimeFormat,
      getNumberFormat,
      getMessageFormat: memoize(function(message, locales, overrideFormats, opts) {
        return new IntlMessageFormat(message, locales, overrideFormats, __assign({ formatters: {
          getNumberFormat,
          getDateTimeFormat,
          getPluralRules
        } }, opts || {}));
      }, {
        cache: createFastMemoizeCache(cache.message),
        strategy: strategies.variadic
      }),
      getRelativeTimeFormat: memoize(function() {
        var args = [];
        for (var _i = 0; _i < arguments.length; _i++) {
          args[_i] = arguments[_i];
        }
        return new (RelativeTimeFormat.bind.apply(RelativeTimeFormat, __spreadArray([void 0], args, false)))();
      }, {
        cache: createFastMemoizeCache(cache.relativeTime),
        strategy: strategies.variadic
      }),
      getPluralRules,
      getListFormat: memoize(function() {
        var args = [];
        for (var _i = 0; _i < arguments.length; _i++) {
          args[_i] = arguments[_i];
        }
        return new (ListFormat.bind.apply(ListFormat, __spreadArray([void 0], args, false)))();
      }, {
        cache: createFastMemoizeCache(cache.list),
        strategy: strategies.variadic
      }),
      getDisplayNames: memoize(function() {
        var args = [];
        for (var _i = 0; _i < arguments.length; _i++) {
          args[_i] = arguments[_i];
        }
        return new (DisplayNames.bind.apply(DisplayNames, __spreadArray([void 0], args, false)))();
      }, {
        cache: createFastMemoizeCache(cache.displayNames),
        strategy: strategies.variadic
      })
    };
  }
  function getNamedFormat(formats, type, name, onError) {
    var formatType = formats && formats[type];
    var format2;
    if (formatType) {
      format2 = formatType[name];
    }
    if (format2) {
      return format2;
    }
    onError(new UnsupportedFormatterError("No ".concat(type, " format named: ").concat(name)));
  }
  function setTimeZoneInOptions(opts, timeZone) {
    return Object.keys(opts).reduce(function(all, k) {
      all[k] = __assign({ timeZone }, opts[k]);
      return all;
    }, {});
  }
  function deepMergeOptions(opts1, opts2) {
    var keys = Object.keys(__assign(__assign({}, opts1), opts2));
    return keys.reduce(function(all, k) {
      all[k] = __assign(__assign({}, opts1[k] || {}), opts2[k] || {});
      return all;
    }, {});
  }
  function deepMergeFormatsAndSetTimeZone(f1, timeZone) {
    if (!timeZone) {
      return f1;
    }
    var mfFormats = IntlMessageFormat.formats;
    return __assign(__assign(__assign({}, mfFormats), f1), { date: deepMergeOptions(setTimeZoneInOptions(mfFormats.date, timeZone), setTimeZoneInOptions(f1.date || {}, timeZone)), time: deepMergeOptions(setTimeZoneInOptions(mfFormats.time, timeZone), setTimeZoneInOptions(f1.time || {}, timeZone)) });
  }
  var formatMessage = function(_a2, state, messageDescriptor, values, opts) {
    var locale = _a2.locale, formats = _a2.formats, messages = _a2.messages, defaultLocale = _a2.defaultLocale, defaultFormats = _a2.defaultFormats, fallbackOnEmptyString = _a2.fallbackOnEmptyString, onError = _a2.onError, timeZone = _a2.timeZone, defaultRichTextElements = _a2.defaultRichTextElements;
    if (messageDescriptor === void 0) {
      messageDescriptor = { id: "" };
    }
    var msgId = messageDescriptor.id, defaultMessage = messageDescriptor.defaultMessage;
    invariant(!!msgId, "[@formatjs/intl] An `id` must be provided to format a message. You can either:\n1. Configure your build toolchain with [babel-plugin-formatjs](https://formatjs.github.io/docs/tooling/babel-plugin)\nor [@formatjs/ts-transformer](https://formatjs.github.io/docs/tooling/ts-transformer) OR\n2. Configure your `eslint` config to include [eslint-plugin-formatjs](https://formatjs.github.io/docs/tooling/linter#enforce-id)\nto autofix this issue");
    var id = String(msgId);
    var message = (
      // In case messages is Object.create(null)
      // e.g import('foo.json') from webpack)
      // See https://github.com/formatjs/formatjs/issues/1914
      messages && Object.prototype.hasOwnProperty.call(messages, id) && messages[id]
    );
    if (Array.isArray(message) && message.length === 1 && message[0].type === TYPE.literal) {
      return message[0].value;
    }
    if (!values && message && typeof message === "string" && !defaultRichTextElements) {
      return message.replace(/'\{(.*?)\}'/gi, "{$1}");
    }
    values = __assign(__assign({}, defaultRichTextElements), values || {});
    formats = deepMergeFormatsAndSetTimeZone(formats, timeZone);
    defaultFormats = deepMergeFormatsAndSetTimeZone(defaultFormats, timeZone);
    if (!message) {
      if (fallbackOnEmptyString === false && message === "") {
        return message;
      }
      if (!defaultMessage || locale && locale.toLowerCase() !== defaultLocale.toLowerCase()) {
        onError(new MissingTranslationError(messageDescriptor, locale));
      }
      if (defaultMessage) {
        try {
          var formatter = state.getMessageFormat(defaultMessage, defaultLocale, defaultFormats, opts);
          return formatter.format(values);
        } catch (e) {
          onError(new MessageFormatError('Error formatting default message for: "'.concat(id, '", rendering default message verbatim'), locale, messageDescriptor, e));
          return typeof defaultMessage === "string" ? defaultMessage : id;
        }
      }
      return id;
    }
    try {
      var formatter = state.getMessageFormat(message, locale, formats, __assign({ formatters: state }, opts || {}));
      return formatter.format(values);
    } catch (e) {
      onError(new MessageFormatError('Error formatting message: "'.concat(id, '", using ').concat(defaultMessage ? "default message" : "id", " as fallback."), locale, messageDescriptor, e));
    }
    if (defaultMessage) {
      try {
        var formatter = state.getMessageFormat(defaultMessage, defaultLocale, defaultFormats, opts);
        return formatter.format(values);
      } catch (e) {
        onError(new MessageFormatError('Error formatting the default message for: "'.concat(id, '", rendering message verbatim'), locale, messageDescriptor, e));
      }
    }
    if (typeof message === "string") {
      return message;
    }
    if (typeof defaultMessage === "string") {
      return defaultMessage;
    }
    return id;
  };
  var DATE_TIME_FORMAT_OPTIONS = [
    "formatMatcher",
    "timeZone",
    "hour12",
    "weekday",
    "era",
    "year",
    "month",
    "day",
    "hour",
    "minute",
    "second",
    "timeZoneName",
    "hourCycle",
    "dateStyle",
    "timeStyle",
    "calendar",
    // 'dayPeriod',
    "numberingSystem",
    "fractionalSecondDigits"
  ];
  function getFormatter$2(_a2, type, getDateTimeFormat, options) {
    var locale = _a2.locale, formats = _a2.formats, onError = _a2.onError, timeZone = _a2.timeZone;
    if (options === void 0) {
      options = {};
    }
    var format2 = options.format;
    var defaults = __assign(__assign({}, timeZone && { timeZone }), format2 && getNamedFormat(formats, type, format2, onError));
    var filteredOptions = filterProps(options, DATE_TIME_FORMAT_OPTIONS, defaults);
    if (type === "time" && !filteredOptions.hour && !filteredOptions.minute && !filteredOptions.second && !filteredOptions.timeStyle && !filteredOptions.dateStyle) {
      filteredOptions = __assign(__assign({}, filteredOptions), { hour: "numeric", minute: "numeric" });
    }
    return getDateTimeFormat(locale, filteredOptions);
  }
  function formatDate(config, getDateTimeFormat) {
    var _a2 = [];
    for (var _i = 2; _i < arguments.length; _i++) {
      _a2[_i - 2] = arguments[_i];
    }
    var value2 = _a2[0], _b = _a2[1], options = _b === void 0 ? {} : _b;
    var date2 = typeof value2 === "string" ? new Date(value2 || 0) : value2;
    try {
      return getFormatter$2(config, "date", getDateTimeFormat, options).format(date2);
    } catch (e) {
      config.onError(new IntlFormatError("Error formatting date.", config.locale, e));
    }
    return String(date2);
  }
  function formatTime(config, getDateTimeFormat) {
    var _a2 = [];
    for (var _i = 2; _i < arguments.length; _i++) {
      _a2[_i - 2] = arguments[_i];
    }
    var value2 = _a2[0], _b = _a2[1], options = _b === void 0 ? {} : _b;
    var date2 = typeof value2 === "string" ? new Date(value2 || 0) : value2;
    try {
      return getFormatter$2(config, "time", getDateTimeFormat, options).format(date2);
    } catch (e) {
      config.onError(new IntlFormatError("Error formatting time.", config.locale, e));
    }
    return String(date2);
  }
  function formatDateTimeRange(config, getDateTimeFormat) {
    var _a2 = [];
    for (var _i = 2; _i < arguments.length; _i++) {
      _a2[_i - 2] = arguments[_i];
    }
    var from = _a2[0], to = _a2[1], _b = _a2[2], options = _b === void 0 ? {} : _b;
    var timeZone = config.timeZone, locale = config.locale, onError = config.onError;
    var filteredOptions = filterProps(options, DATE_TIME_FORMAT_OPTIONS, timeZone ? { timeZone } : {});
    try {
      return getDateTimeFormat(locale, filteredOptions).formatRange(from, to);
    } catch (e) {
      onError(new IntlFormatError("Error formatting date time range.", config.locale, e));
    }
    return String(from);
  }
  function formatDateToParts(config, getDateTimeFormat) {
    var _a2 = [];
    for (var _i = 2; _i < arguments.length; _i++) {
      _a2[_i - 2] = arguments[_i];
    }
    var value2 = _a2[0], _b = _a2[1], options = _b === void 0 ? {} : _b;
    var date2 = typeof value2 === "string" ? new Date(value2 || 0) : value2;
    try {
      return getFormatter$2(config, "date", getDateTimeFormat, options).formatToParts(date2);
    } catch (e) {
      config.onError(new IntlFormatError("Error formatting date.", config.locale, e));
    }
    return [];
  }
  function formatTimeToParts(config, getDateTimeFormat) {
    var _a2 = [];
    for (var _i = 2; _i < arguments.length; _i++) {
      _a2[_i - 2] = arguments[_i];
    }
    var value2 = _a2[0], _b = _a2[1], options = _b === void 0 ? {} : _b;
    var date2 = typeof value2 === "string" ? new Date(value2 || 0) : value2;
    try {
      return getFormatter$2(config, "time", getDateTimeFormat, options).formatToParts(date2);
    } catch (e) {
      config.onError(new IntlFormatError("Error formatting time.", config.locale, e));
    }
    return [];
  }
  var DISPLAY_NAMES_OPTONS = [
    "style",
    "type",
    "fallback",
    "languageDisplay"
  ];
  function formatDisplayName(_a2, getDisplayNames, value2, options) {
    var locale = _a2.locale, onError = _a2.onError;
    var DisplayNames = Intl.DisplayNames;
    if (!DisplayNames) {
      onError(new FormatError('Intl.DisplayNames is not available in this environment.\nTry polyfilling it using "@formatjs/intl-displaynames"\n', ErrorCode.MISSING_INTL_API));
    }
    var filteredOptions = filterProps(options, DISPLAY_NAMES_OPTONS);
    try {
      return getDisplayNames(locale, filteredOptions).of(value2);
    } catch (e) {
      onError(new IntlFormatError("Error formatting display name.", locale, e));
    }
  }
  var LIST_FORMAT_OPTIONS = [
    "type",
    "style"
  ];
  var now = Date.now();
  function generateToken(i) {
    return "".concat(now, "_").concat(i, "_").concat(now);
  }
  function formatList(opts, getListFormat, values, options) {
    if (options === void 0) {
      options = {};
    }
    var results = formatListToParts(opts, getListFormat, values, options).reduce(function(all, el) {
      var val = el.value;
      if (typeof val !== "string") {
        all.push(val);
      } else if (typeof all[all.length - 1] === "string") {
        all[all.length - 1] += val;
      } else {
        all.push(val);
      }
      return all;
    }, []);
    return results.length === 1 ? results[0] : results.length === 0 ? "" : results;
  }
  function formatListToParts(_a2, getListFormat, values, options) {
    var locale = _a2.locale, onError = _a2.onError;
    if (options === void 0) {
      options = {};
    }
    var ListFormat = Intl.ListFormat;
    if (!ListFormat) {
      onError(new FormatError('Intl.ListFormat is not available in this environment.\nTry polyfilling it using "@formatjs/intl-listformat"\n', ErrorCode.MISSING_INTL_API));
    }
    var filteredOptions = filterProps(options, LIST_FORMAT_OPTIONS);
    try {
      var richValues_1 = {};
      var serializedValues = values.map(function(v, i) {
        if (typeof v === "object") {
          var id = generateToken(i);
          richValues_1[id] = v;
          return id;
        }
        return String(v);
      });
      return getListFormat(locale, filteredOptions).formatToParts(serializedValues).map(function(part) {
        return part.type === "literal" ? part : __assign(__assign({}, part), { value: richValues_1[part.value] || part.value });
      });
    } catch (e) {
      onError(new IntlFormatError("Error formatting list.", locale, e));
    }
    return values;
  }
  var PLURAL_FORMAT_OPTIONS = ["type"];
  function formatPlural(_a2, getPluralRules, value2, options) {
    var locale = _a2.locale, onError = _a2.onError;
    if (options === void 0) {
      options = {};
    }
    if (!Intl.PluralRules) {
      onError(new FormatError('Intl.PluralRules is not available in this environment.\nTry polyfilling it using "@formatjs/intl-pluralrules"\n', ErrorCode.MISSING_INTL_API));
    }
    var filteredOptions = filterProps(options, PLURAL_FORMAT_OPTIONS);
    try {
      return getPluralRules(locale, filteredOptions).select(value2);
    } catch (e) {
      onError(new IntlFormatError("Error formatting plural.", locale, e));
    }
    return "other";
  }
  var RELATIVE_TIME_FORMAT_OPTIONS = ["numeric", "style"];
  function getFormatter$1(_a2, getRelativeTimeFormat, options) {
    var locale = _a2.locale, formats = _a2.formats, onError = _a2.onError;
    if (options === void 0) {
      options = {};
    }
    var format2 = options.format;
    var defaults = !!format2 && getNamedFormat(formats, "relative", format2, onError) || {};
    var filteredOptions = filterProps(options, RELATIVE_TIME_FORMAT_OPTIONS, defaults);
    return getRelativeTimeFormat(locale, filteredOptions);
  }
  function formatRelativeTime(config, getRelativeTimeFormat, value2, unit, options) {
    if (options === void 0) {
      options = {};
    }
    if (!unit) {
      unit = "second";
    }
    var RelativeTimeFormat = Intl.RelativeTimeFormat;
    if (!RelativeTimeFormat) {
      config.onError(new FormatError('Intl.RelativeTimeFormat is not available in this environment.\nTry polyfilling it using "@formatjs/intl-relativetimeformat"\n', ErrorCode.MISSING_INTL_API));
    }
    try {
      return getFormatter$1(config, getRelativeTimeFormat, options).format(value2, unit);
    } catch (e) {
      config.onError(new IntlFormatError("Error formatting relative time.", config.locale, e));
    }
    return String(value2);
  }
  var NUMBER_FORMAT_OPTIONS = [
    "style",
    "currency",
    "unit",
    "unitDisplay",
    "useGrouping",
    "minimumIntegerDigits",
    "minimumFractionDigits",
    "maximumFractionDigits",
    "minimumSignificantDigits",
    "maximumSignificantDigits",
    // ES2020 NumberFormat
    "compactDisplay",
    "currencyDisplay",
    "currencySign",
    "notation",
    "signDisplay",
    "unit",
    "unitDisplay",
    "numberingSystem",
    // ES2023 NumberFormat
    // @ts-expect-error: TypeScript doesn't know about this yet
    "trailingZeroDisplay",
    // @ts-expect-error: TypeScript doesn't know about this yet
    "roundingPriority",
    // @ts-expect-error: TypeScript doesn't know about this yet
    "roundingIncrement",
    // @ts-expect-error: TypeScript doesn't know about this yet
    "roundingMode"
  ];
  function getFormatter(_a2, getNumberFormat, options) {
    var locale = _a2.locale, formats = _a2.formats, onError = _a2.onError;
    if (options === void 0) {
      options = {};
    }
    var format2 = options.format;
    var defaults = format2 && getNamedFormat(formats, "number", format2, onError) || {};
    var filteredOptions = filterProps(options, NUMBER_FORMAT_OPTIONS, defaults);
    return getNumberFormat(locale, filteredOptions);
  }
  function formatNumber(config, getNumberFormat, value2, options) {
    if (options === void 0) {
      options = {};
    }
    try {
      return getFormatter(config, getNumberFormat, options).format(value2);
    } catch (e) {
      config.onError(new IntlFormatError("Error formatting number.", config.locale, e));
    }
    return String(value2);
  }
  function formatNumberToParts(config, getNumberFormat, value2, options) {
    if (options === void 0) {
      options = {};
    }
    try {
      return getFormatter(config, getNumberFormat, options).formatToParts(value2);
    } catch (e) {
      config.onError(new IntlFormatError("Error formatting number.", config.locale, e));
    }
    return [];
  }
  function messagesContainString(messages) {
    var firstMessage = messages ? messages[Object.keys(messages)[0]] : void 0;
    return typeof firstMessage === "string";
  }
  function verifyConfigMessages(config) {
    if (config.onWarn && config.defaultRichTextElements && messagesContainString(config.messages || {})) {
      config.onWarn('[@formatjs/intl] "defaultRichTextElements" was specified but "message" was not pre-compiled. \nPlease consider using "@formatjs/cli" to pre-compile your messages for performance.\nFor more details see https://formatjs.github.io/docs/getting-started/message-distribution');
    }
  }
  function createIntl(config, cache) {
    var formatters = createFormatters(cache);
    var resolvedConfig = __assign(__assign({}, DEFAULT_INTL_CONFIG), config);
    var locale = resolvedConfig.locale, defaultLocale = resolvedConfig.defaultLocale, onError = resolvedConfig.onError;
    if (!locale) {
      if (onError) {
        onError(new InvalidConfigError('"locale" was not configured, using "'.concat(defaultLocale, '" as fallback. See https://formatjs.github.io/docs/react-intl/api#intlshape for more details')));
      }
      resolvedConfig.locale = resolvedConfig.defaultLocale || "en";
    } else if (!Intl.NumberFormat.supportedLocalesOf(locale).length && onError) {
      onError(new MissingDataError('Missing locale data for locale: "'.concat(locale, '" in Intl.NumberFormat. Using default locale: "').concat(defaultLocale, '" as fallback. See https://formatjs.github.io/docs/react-intl#runtime-requirements for more details')));
    } else if (!Intl.DateTimeFormat.supportedLocalesOf(locale).length && onError) {
      onError(new MissingDataError('Missing locale data for locale: "'.concat(locale, '" in Intl.DateTimeFormat. Using default locale: "').concat(defaultLocale, '" as fallback. See https://formatjs.github.io/docs/react-intl#runtime-requirements for more details')));
    }
    verifyConfigMessages(resolvedConfig);
    return __assign(__assign({}, resolvedConfig), { formatters, formatNumber: formatNumber.bind(null, resolvedConfig, formatters.getNumberFormat), formatNumberToParts: formatNumberToParts.bind(null, resolvedConfig, formatters.getNumberFormat), formatRelativeTime: formatRelativeTime.bind(null, resolvedConfig, formatters.getRelativeTimeFormat), formatDate: formatDate.bind(null, resolvedConfig, formatters.getDateTimeFormat), formatDateToParts: formatDateToParts.bind(null, resolvedConfig, formatters.getDateTimeFormat), formatTime: formatTime.bind(null, resolvedConfig, formatters.getDateTimeFormat), formatDateTimeRange: formatDateTimeRange.bind(null, resolvedConfig, formatters.getDateTimeFormat), formatTimeToParts: formatTimeToParts.bind(null, resolvedConfig, formatters.getDateTimeFormat), formatPlural: formatPlural.bind(null, resolvedConfig, formatters.getPluralRules), formatMessage: formatMessage.bind(null, resolvedConfig, formatters), $t: formatMessage.bind(null, resolvedConfig, formatters), formatList: formatList.bind(null, resolvedConfig, formatters.getListFormat), formatListToParts: formatListToParts.bind(null, resolvedConfig, formatters.getListFormat), formatDisplayName: formatDisplayName.bind(null, resolvedConfig, formatters.getDisplayNames) });
  }
  const fhirMessages = {
    "fhir.boolean.false": [
      {
        type: 0,
        value: "Nee"
      }
    ],
    "fhir.boolean.true": [
      {
        type: 0,
        value: "Ja"
      }
    ],
    "fhir.duration_days": [
      {
        offset: 0,
        options: {
          one: {
            value: [
              {
                type: 0,
                value: "één dag"
              }
            ]
          },
          other: {
            value: [
              {
                style: null,
                type: 2,
                value: "count"
              },
              {
                type: 0,
                value: " dagen"
              }
            ]
          }
        },
        pluralType: "cardinal",
        type: 6,
        value: "count"
      }
    ],
    "fhir.group_general_info": [
      {
        type: 0,
        value: "Algemeen"
      }
    ],
    "fhir.period.end": [
      {
        type: 0,
        value: "Eind datum"
      }
    ],
    "fhir.period.start": [
      {
        type: 0,
        value: "Begin datum"
      }
    ],
    "fhir.range.high": [
      {
        type: 0,
        value: "Bovengrens"
      }
    ],
    "fhir.range.low": [
      {
        type: 0,
        value: "Ondergrens"
      }
    ],
    "fhir.ratio.denominator": [
      {
        type: 0,
        value: "Noemer"
      }
    ],
    "fhir.ratio.numerator": [
      {
        type: 0,
        value: "Teller"
      }
    ],
    "fhir.unknown": [
      {
        type: 0,
        value: "Onbekend"
      }
    ],
    "format.code_in_system": [
      {
        type: 1,
        value: "code"
      },
      {
        type: 0,
        value: " in code systeem "
      },
      {
        type: 1,
        value: "system"
      }
    ],
    "schema.empty_entry_display": [
      {
        type: 0,
        value: "Niet bekend"
      }
    ],
    "system.urn:oid:2.16.840.1.113883.2.4.4.9": [
      {
        type: 0,
        value: "G-Standaard Toedieningswegen (tabel 7)"
      }
    ],
    "zib_medication_use.repeat_period_cyclical_schedule": [
      {
        type: 0,
        value: "Herhaalperiode cyclisch schema"
      }
    ]
  };
  const gp_encounter_report = [
    {
      type: 0,
      value: "Deelcontactverslag"
    }
  ];
  const nl_core_address = [
    {
      type: 0,
      value: "Adres informatie"
    }
  ];
  const nl_core_contactpoint = [
    {
      type: 0,
      value: "Contactgegevens"
    }
  ];
  const nl_core_organization = [
    {
      type: 0,
      value: "Zorgaanbieder"
    }
  ];
  const nl_core_patient = [
    {
      type: 0,
      value: "Patiënt"
    }
  ];
  const nl_core_practitioner = [
    {
      type: 0,
      value: "Zorgverlener"
    }
  ];
  const zib_ability_to_dress_oneself = [
    {
      type: 0,
      value: "Vermogen tot zich kleden"
    }
  ];
  const zib_ability_to_drink = [
    {
      type: 0,
      value: "Vermogen tot drinken"
    }
  ];
  const zib_ability_to_eat = [
    {
      type: 0,
      value: "Vermogen tot eten"
    }
  ];
  const zib_ability_to_groome = [
    {
      type: 0,
      value: "Vermogen tot uiterlijke verzorging"
    }
  ];
  const zib_ability_to_manage_medication = [
    {
      type: 0,
      value: "Ability to manage medication"
    }
  ];
  const zib_ability_to_perform_mouthcare_activities = [
    {
      type: 0,
      value: "Vermogen tot mondverzorging"
    }
  ];
  const zib_ability_to_perform_mouthcare_activities_medical_device = [
    {
      type: 0,
      value: "Prothese"
    }
  ];
  const zib_ability_to_perform_nursing_activities = [
    {
      type: 0,
      value: "Vermogen tot verpleegtechnische handelingen"
    }
  ];
  const zib_ability_to_use_toilet = [
    {
      type: 0,
      value: "Vermogen tot toiletgang"
    }
  ];
  const zib_ability_to_wash_one_self = [
    {
      type: 0,
      value: "Vermogen tot zich wassen"
    }
  ];
  const zib_administration_agreement = [
    {
      type: 0,
      value: "Toedieningsafspraak"
    }
  ];
  const zib_administration_schedule = [
    {
      type: 0,
      value: "Toedieningsschema"
    }
  ];
  const zib_advance_directive = [
    {
      type: 0,
      value: "Wilsverklaring"
    }
  ];
  const zib_alcohol_use = [
    {
      type: 0,
      value: "Alcohol gebruik"
    }
  ];
  const zib_allergy_intolerance = [
    {
      type: 0,
      value: "Allergie intolerantie"
    }
  ];
  const zib_bladder_function = [
    {
      type: 0,
      value: "Blaasfunctie"
    }
  ];
  const zib_blood_pressure = [
    {
      type: 0,
      value: "Bloeddruk"
    }
  ];
  const zib_body_height = [
    {
      type: 0,
      value: "Lichaamslengte"
    }
  ];
  const zib_body_temperature = [
    {
      type: 0,
      value: "Lichaamstemperatuur"
    }
  ];
  const zib_body_weight = [
    {
      type: 0,
      value: "Lichaamsgewicht"
    }
  ];
  const zib_bowel_function = [
    {
      type: 0,
      value: "Darmfunctie"
    }
  ];
  const zib_burn_wound = [
    {
      type: 0,
      value: "Brandwond"
    }
  ];
  const zib_burn_wound_extent = [
    {
      type: 0,
      value: "Uitgebreidheid"
    }
  ];
  const zib_checklist_pain_behaviour = [
    {
      type: 0,
      value: "Checklist pijn gedrag"
    }
  ];
  const zib_comfort_scale = [
    {
      type: 0,
      value: "Comfort score"
    }
  ];
  const zib_contact_information_telecom_type = [
    {
      type: 0,
      value: "Definieert een specifieke gecodeerde waarde voor het concept telecom type gebruikt in de zib contactgegevens, zodat de in de zib gedefinieerde waardelijst kan worden gebruikt."
    }
  ];
  const zib_development_child = [
    {
      type: 0,
      value: "Ontwikkeling kind"
    }
  ];
  const zib_dispense = [
    {
      type: 0,
      value: "Verstrekking"
    }
  ];
  const zib_dispense_request = [
    {
      type: 0,
      value: "Verstrekkingsverzoek"
    }
  ];
  const zib_drug_use = [
    {
      type: 0,
      value: "Drugs gebruik"
    }
  ];
  const zib_encounter = [
    {
      type: 0,
      value: "Contact"
    }
  ];
  const zib_family_situation = [
    {
      type: 0,
      value: "Gezinssituatie"
    }
  ];
  const zib_family_situation_child = [
    {
      type: 0,
      value: "Gezinssituatie kind"
    }
  ];
  const zib_family_situation_living_at_home_indicator = [
    {
      type: 0,
      value: "Inwonend"
    }
  ];
  const zib_feeding_pattern_infant = [
    {
      type: 0,
      value: "Voedingspatroon zuigeling"
    }
  ];
  const zib_feeding_tube_system = [
    {
      type: 0,
      value: "Sonde systeem"
    }
  ];
  const zib_feeding_tube_system_enteral_nutrition = [
    {
      type: 0,
      value: "Sonde voeding"
    }
  ];
  const zib_feeding_tube_system_feeding_tube_length = [
    {
      type: 0,
      value: "Sonde lengte"
    }
  ];
  const zib_flacc_pain_scale = [
    {
      type: 0,
      value: "FLAC cpijn score"
    }
  ];
  const zib_fluid_balance = [
    {
      type: 0,
      value: "Vochtbalans"
    }
  ];
  const zib_freedom_restricting_measures = [
    {
      type: 0,
      value: "Vrijheidsbeperkende maatregelen"
    }
  ];
  const zib_freedom_restricting_measures_permission = [
    {
      type: 0,
      value: "Toestemming"
    }
  ];
  const zib_functional_or_mental_status = [
    {
      type: 0,
      value: "Functionele of mentale status"
    }
  ];
  const zib_general_measurement = [
    {
      type: 0,
      value: "Meet uitslag"
    }
  ];
  const zib_head_circumference = [
    {
      type: 0,
      value: "Schedelomvang"
    }
  ];
  const zib_hearing_function = [
    {
      type: 0,
      value: "Functie horen"
    }
  ];
  const zib_hearing_function_hearing_aid = [
    {
      type: 0,
      value: "Horen hulpmiddel"
    }
  ];
  const zib_heart_rate = [
    {
      type: 0,
      value: "Hartfrequentie"
    }
  ];
  const zib_illness_perception = [
    {
      type: 0,
      value: "Ziektebeleving"
    }
  ];
  const zib_infusion = [
    {
      type: 0,
      value: "Infuus"
    }
  ];
  const zib_infusion_lumen_or_line = [
    {
      type: 0,
      value: "Lumen of lijn"
    }
  ];
  const zib_instructions_for_use = [
    {
      type: 0,
      value: "Gebruiksinstructie"
    }
  ];
  const zib_laboratory_test_result_diagnostic_report = [
    {
      type: 0,
      value: "Laboratorium uitslag"
    }
  ];
  const zib_laboratory_test_result_observation = [
    {
      type: 0,
      value: "Laboratorium uitslag"
    }
  ];
  const zib_laboratory_test_result_specimen = [
    {
      type: 0,
      value: "Monster"
    }
  ];
  const zib_laboratory_test_result_specimen_isolate = [
    {
      type: 0,
      value: "Monster"
    }
  ];
  const zib_living_situation = [
    {
      type: 0,
      value: "Woonsituatie"
    }
  ];
  const zib_medical_device = [
    {
      type: 0,
      value: "Medisch hulpmiddel"
    }
  ];
  const zib_medical_device_product = [
    {
      type: 0,
      value: "Product"
    }
  ];
  const zib_medication_administration = [
    {
      type: 0,
      value: "Medicatie toediening"
    }
  ];
  const zib_medication_agreement = [
    {
      type: 0,
      value: "Medicatieafspraak"
    }
  ];
  const zib_medication_period_of_use = [
    {
      type: 0,
      value: "Gebruiksperiode"
    }
  ];
  const zib_medication_use = [
    {
      type: 0,
      value: "Medicatiegebruik"
    }
  ];
  const zib_mobility = [
    {
      type: 0,
      value: "Mobiliteit"
    }
  ];
  const zib_must_score = [
    {
      type: 0,
      value: "MUST score"
    }
  ];
  const zib_nursing_intervention = [
    {
      type: 0,
      value: "Verpleegkundige interventie"
    }
  ];
  const zib_nursing_intervention_interval = [
    {
      type: 0,
      value: "Interval"
    }
  ];
  const zib_nutrition_advice = [
    {
      type: 0,
      value: "Voedingsadvies"
    }
  ];
  const zib_outcome_of_care = [
    {
      type: 0,
      value: "Uitkomst van zorg"
    }
  ];
  const zib_oxygen_saturation = [
    {
      type: 0,
      value: "O2 saturatie"
    }
  ];
  const zib_pain_score = [
    {
      type: 0,
      value: "Pijnscore"
    }
  ];
  const zib_participation_in_society = [
    {
      type: 0,
      value: "Participatie in maatschappij"
    }
  ];
  const zib_payer = [
    {
      type: 0,
      value: "Verzekering"
    }
  ];
  const zib_payer_bank_information = [
    {
      type: 0,
      value: "Bankgegevens"
    }
  ];
  const zib_pregnancy = [
    {
      type: 0,
      value: "Zwangerschap"
    }
  ];
  const zib_pressure_ulcer = [
    {
      type: 0,
      value: "Decubitus wond"
    }
  ];
  const zib_problem = [
    {
      type: 0,
      value: "Concern"
    }
  ];
  const zib_procedure = [
    {
      type: 0,
      value: "Verrichting"
    }
  ];
  const zib_procedure_request = [
    {
      type: 0,
      value: "Verrichting"
    }
  ];
  const zib_product = [
    {
      type: 0,
      value: "Geneesmiddel"
    }
  ];
  const zib_pulse_rate = [
    {
      type: 0,
      value: "Polsfrequentie"
    }
  ];
  const zib_respiration_administered_oxygen_administration_device = [
    {
      type: 0,
      value: "Toediening hulpmiddel"
    }
  ];
  const zib_skin_disorder = [
    {
      type: 0,
      value: "Huidaandoening"
    }
  ];
  const zib_sna_qrc_score = [
    {
      type: 0,
      value: "SNA qrc score"
    }
  ];
  const zib_snaq_65_plus_score = [
    {
      type: 0,
      value: "SNAQ65+score"
    }
  ];
  const zib_snaq_score = [
    {
      type: 0,
      value: "SNAQ score"
    }
  ];
  const zib_stoma = [
    {
      type: 0,
      value: "Stoma"
    }
  ];
  const zib_strong_kids_score = [
    {
      type: 0,
      value: "Strong kids score"
    }
  ];
  const zib_text_result = [
    {
      type: 0,
      value: "Tekst uitslag"
    }
  ];
  const zib_tobacco_use = [
    {
      type: 0,
      value: "Tabak gebruik"
    }
  ];
  const zib_treatment_directive = [
    {
      type: 0,
      value: "Behandel aanwijzing"
    }
  ];
  const zib_treatment_directive_verification = [
    {
      type: 0,
      value: "Verificatie"
    }
  ];
  const zib_treatment_objective = [
    {
      type: 0,
      value: "Behandeldoel"
    }
  ];
  const zib_vaccination = [
    {
      type: 0,
      value: "Vaccinatie"
    }
  ];
  const zib_visual_function = [
    {
      type: 0,
      value: "Functie zien"
    }
  ];
  const zib_visual_function_visual_aid = [
    {
      type: 0,
      value: "Zien hulpmiddel"
    }
  ];
  const zib_wound = [
    {
      type: 0,
      value: "Wond"
    }
  ];
  const resourceLabels = {
    gp_encounter_report,
    "gp_journal_entry.value": [
      {
        type: 0,
        value: "Journaalregel tekst"
      }
    ],
    nl_core_address,
    "nl_core_address.address_type.value": [
      {
        type: 0,
        value: "Adres soort"
      }
    ],
    "nl_core_address.city": [
      {
        type: 0,
        value: "Municipality"
      }
    ],
    "nl_core_address.country": [
      {
        type: 0,
        value: "Land"
      }
    ],
    "nl_core_address.country.country_code.value": [
      {
        type: 0,
        value: "Land GBA codelijst"
      }
    ],
    "nl_core_address.district": [
      {
        type: 0,
        value: "Gemeente"
      }
    ],
    "nl_core_address.official": [
      {
        type: 0,
        value: "Markeer een adres als een 'officieel geregistreerd adres."
      }
    ],
    "nl_core_address.postal_code": [
      {
        type: 0,
        value: "Postcode"
      }
    ],
    "nl_core_address.state": [
      {
        type: 0,
        value: "Provincie"
      }
    ],
    "nl_core_address_official.value": [
      {
        type: 0,
        value: "True als deze deel is van een officieel register. false indien dat niet het geval is"
      }
    ],
    "nl_core_careplan.nursing_intervention.detail.code": [
      {
        type: 0,
        value: "Interventie"
      }
    ],
    "nl_core_careplan.nursing_intervention.detail.goal": [
      {
        type: 0,
        value: "Behandeldoel"
      }
    ],
    "nl_core_careplan.nursing_intervention.detail.medical_device": [
      {
        type: 0,
        value: "Medisch hulpmiddel"
      }
    ],
    "nl_core_careplan.nursing_intervention.detail.performer": [
      {
        type: 0,
        value: "Uitvoerder"
      }
    ],
    "nl_core_careplan.nursing_intervention.detail.reason_reference": [
      {
        type: 0,
        value: "Indicatie"
      }
    ],
    "nl_core_careplan.nursing_intervention.detail.scheduled_timing.repeat.bounds_period.end": [
      {
        type: 0,
        value: "Actie eind datum tijd"
      }
    ],
    "nl_core_careplan.nursing_intervention.detail.scheduled_timing.repeat.bounds_period.start": [
      {
        type: 0,
        value: "Actie start datum tijd"
      }
    ],
    "nl_core_careplan.nursing_intervention.detail.scheduled_timing.repeat.frequency": [
      {
        type: 0,
        value: "Frequentie"
      }
    ],
    "nl_core_careplan.nursing_intervention.detail.scheduled_timing.repeat.period": [
      {
        type: 0,
        value: "Interval"
      }
    ],
    "nl_core_careplan.nursing_intervention.outcome_codeable_concept.text": [
      {
        type: 0,
        value: "Zorgresultaat"
      }
    ],
    "nl_core_careplan.nursing_intervention.outcome_reference": [
      {
        type: 0,
        value: "Meetwaarde"
      }
    ],
    "nl_core_careteam.participant.role.health_professional_role": [
      {
        type: 0,
        value: "Zorgverlener rol"
      }
    ],
    nl_core_contactpoint,
    "nl_core_contactpoint.system": [
      {
        type: 0,
        value: "Telecom type / email soort"
      }
    ],
    "nl_core_contactpoint.telecom_type": [
      {
        type: 0,
        value: "Telecom type"
      }
    ],
    "nl_core_contactpoint.use": [
      {
        type: 0,
        value: "Telecom type / nummer soort / email soort"
      }
    ],
    "nl_core_contactpoint.value": [
      {
        type: 0,
        value: "Telefoonnummer / e-mailadres"
      }
    ],
    "nl_core_episodeofcare.type.text": [
      {
        type: 0,
        value: "Concern label"
      }
    ],
    "nl_core_healthcareservice.telecom": [
      {
        type: 0,
        value: "Contactgegevens"
      }
    ],
    "nl_core_humanname.family": [
      {
        type: 0,
        value: "Achternaam"
      }
    ],
    "nl_core_humanname.family.humanname_own_name": [
      {
        type: 0,
        value: "Geslachtsnaam"
      }
    ],
    "nl_core_humanname.family.humanname_own_prefix": [
      {
        type: 0,
        value: "Voorvoegsel geslachtsnaam"
      }
    ],
    "nl_core_humanname.family.humanname_partner_name": [
      {
        type: 0,
        value: "Geslachtsnaam partner"
      }
    ],
    "nl_core_humanname.family.humanname_partner_prefix": [
      {
        type: 0,
        value: "Voorvoegsel geslachtsnaam partner"
      }
    ],
    "nl_core_humanname.given": [
      {
        type: 0,
        value: "Voornamen"
      }
    ],
    "nl_core_humanname.humanname_assembly_order": [
      {
        type: 0,
        value: "Voorkeursvolgorde van de naamdelen."
      }
    ],
    "nl_core_location.address": [
      {
        type: 0,
        value: "Adresgegevens"
      }
    ],
    "nl_core_location.name": [
      {
        type: 0,
        value: "Organization location"
      }
    ],
    "nl_core_location.telecom": [
      {
        type: 0,
        value: "Contactgegevens"
      }
    ],
    nl_core_organization,
    "nl_core_organization.address": [
      {
        type: 0,
        value: "Adresgegevens"
      }
    ],
    "nl_core_organization.agb": [
      {
        type: 0,
        value: "AGB"
      }
    ],
    "nl_core_organization.agb.value": [
      {
        type: 0,
        value: "AGB-z (vektis AGB-z zorgverlenertabel)"
      }
    ],
    "nl_core_organization.alias": [
      {
        type: 0,
        value: "Organisatie alias"
      }
    ],
    "nl_core_organization.department_specialty": [
      {
        type: 0,
        value: "Afdeling specialisme"
      }
    ],
    "nl_core_organization.name": [
      {
        type: 0,
        value: "Organisatie naam of afdeling naam"
      }
    ],
    "nl_core_organization.organization_type": [
      {
        type: 0,
        value: "Organisatie type"
      }
    ],
    "nl_core_organization.telecom": [
      {
        type: 0,
        value: "Contactgegevens"
      }
    ],
    "nl_core_organization.ura": [
      {
        type: 0,
        value: "URA"
      }
    ],
    "nl_core_organization.ura.value": [
      {
        type: 0,
        value: "URA (UZI-register abonneenummer)"
      }
    ],
    "nl_core_organization.uzovi": [
      {
        type: 0,
        value: "UZOVI"
      }
    ],
    "nl_core_organization.uzovi.value": [
      {
        type: 0,
        value: "Unieke zorgverekeraar identificatie (het UZOVI-nummer)"
      }
    ],
    nl_core_patient,
    "nl_core_patient.address": [
      {
        type: 0,
        value: "Adresgegevens"
      }
    ],
    "nl_core_patient.birth_date": [
      {
        type: 0,
        value: "Geboortedatum"
      }
    ],
    "nl_core_patient.bsn": [
      {
        type: 0,
        value: "BSN"
      }
    ],
    "nl_core_patient.bsn.value": [
      {
        type: 0,
        value: "BSN"
      }
    ],
    "nl_core_patient.communication": [
      {
        type: 0,
        value: "Taalvaardigheid"
      }
    ],
    "nl_core_patient.communication.language": [
      {
        type: 0,
        value: "Communicatie taal"
      }
    ],
    "nl_core_patient.contact": [
      {
        type: 0,
        value: "Contactpersoon"
      }
    ],
    "nl_core_patient.contact.address": [
      {
        type: 0,
        value: "Adresgegevens"
      }
    ],
    "nl_core_patient.contact.name": [
      {
        type: 0,
        value: "Naamgegevens"
      }
    ],
    "nl_core_patient.contact.relationship": [
      {
        type: 0,
        value: "Relatie"
      }
    ],
    "nl_core_patient.contact.role": [
      {
        type: 0,
        value: "Rol"
      }
    ],
    "nl_core_patient.deceased": [
      {
        type: 0,
        value: "Overlijdensindicator/datum overlijden"
      }
    ],
    "nl_core_patient.gender": [
      {
        type: 0,
        value: "Geslacht"
      }
    ],
    "nl_core_patient.gender.geslacht_codelijst": [
      {
        type: 0,
        value: "Geslacht"
      }
    ],
    "nl_core_patient.general_practitioner": [
      {
        type: 0,
        value: "Huisarts"
      }
    ],
    "nl_core_patient.identifier": [
      {
        type: 0,
        value: "Identificatienummer"
      }
    ],
    "nl_core_patient.marital_status": [
      {
        type: 0,
        value: "Burgerlijke staat"
      }
    ],
    "nl_core_patient.multiple_birth": [
      {
        type: 0,
        value: "Meerlingindicator"
      }
    ],
    "nl_core_patient.name": [
      {
        type: 0,
        value: "Naamgegevens"
      }
    ],
    "nl_core_patient.nationality": [
      {
        type: 0,
        value: "Nationaliteit"
      }
    ],
    "nl_core_patient.preferred_pharmacy": [
      {
        type: 0,
        value: "Verwijst naar de voorkeursapotheek van de patiënt"
      }
    ],
    "nl_core_person.address": [
      {
        type: 0,
        value: "Adresgegevens"
      }
    ],
    "nl_core_person.birth_date": [
      {
        type: 0,
        value: "Geboortedatum"
      }
    ],
    "nl_core_person.bsn": [
      {
        type: 0,
        value: "BSN"
      }
    ],
    "nl_core_person.bsn.value": [
      {
        type: 0,
        value: "BSN"
      }
    ],
    "nl_core_person.gender": [
      {
        type: 0,
        value: "Geslacht"
      }
    ],
    "nl_core_person.identifier": [
      {
        type: 0,
        value: "Identificatienummer"
      }
    ],
    "nl_core_person.name": [
      {
        type: 0,
        value: "Naamgegevens"
      }
    ],
    "nl_core_person.telecom": [
      {
        type: 0,
        value: "Contactgegevens"
      }
    ],
    nl_core_practitioner,
    "nl_core_practitioner.address": [
      {
        type: 0,
        value: "Adresgegevens"
      }
    ],
    "nl_core_practitioner.agb": [
      {
        type: 0,
        value: "AGB"
      }
    ],
    "nl_core_practitioner.big": [
      {
        type: 0,
        value: "BIG"
      }
    ],
    "nl_core_practitioner.identifier": [
      {
        type: 0,
        value: "Zorgverlener identificatie nummer"
      }
    ],
    "nl_core_practitioner.name": [
      {
        type: 0,
        value: "Naamgegevens"
      }
    ],
    "nl_core_practitioner.uzi": [
      {
        type: 0,
        value: "UZI"
      }
    ],
    "nl_core_practitionerrole.organization": [
      {
        type: 0,
        value: "Zorgaanbieder"
      }
    ],
    "nl_core_practitionerrole.specialty": [
      {
        type: 0,
        value: "Specialisme"
      }
    ],
    "nl_core_practitionerrole.specialty.specialty_agb": [
      {
        type: 0,
        value: "Specialisme AGB"
      }
    ],
    "nl_core_practitionerrole.specialty.specialty_uzi": [
      {
        type: 0,
        value: "Specialisme UZI"
      }
    ],
    "nl_core_relatedperson.address": [
      {
        type: 0,
        value: "Adresgegevens"
      }
    ],
    "nl_core_relatedperson.name": [
      {
        type: 0,
        value: "Naamgegevens"
      }
    ],
    "nl_core_relatedperson.relationship": [
      {
        type: 0,
        value: "Relatie"
      }
    ],
    "nl_core_relatedperson.role": [
      {
        type: 0,
        value: "Rol"
      }
    ],
    "nl_core_relatedperson_role.value": [
      {
        type: 0,
        value: "Rol"
      }
    ],
    zib_ability_to_dress_oneself,
    "zib_ability_to_dress_oneself.body_part_to_be_dressed.value": [
      {
        type: 0,
        value: "Te kleden lichaamsdeel"
      }
    ],
    "zib_ability_to_dress_oneself.value": [
      {
        type: 0,
        value: "Zich kleden"
      }
    ],
    zib_ability_to_drink,
    "zib_ability_to_drink.drinking_limitations.value": [
      {
        type: 0,
        value: "Drink beperkingen"
      }
    ],
    "zib_ability_to_drink.value": [
      {
        type: 0,
        value: "Drinken"
      }
    ],
    zib_ability_to_eat,
    "zib_ability_to_eat.eating_limitations.value": [
      {
        type: 0,
        value: "Eet beperkingen"
      }
    ],
    "zib_ability_to_eat.value": [
      {
        type: 0,
        value: "Eten"
      }
    ],
    zib_ability_to_groome,
    "zib_ability_to_groome.value": [
      {
        type: 0,
        value: "Uiterlijke verzorging"
      }
    ],
    zib_ability_to_manage_medication,
    "zib_ability_to_manage_medication.required_assistance.value": [
      {
        type: 0,
        value: "Hulp bij toediening"
      }
    ],
    "zib_ability_to_manage_medication.value": [
      {
        type: 0,
        value: "Zelfstandig medicatiegebruik"
      }
    ],
    zib_ability_to_perform_mouthcare_activities,
    "zib_ability_to_perform_mouthcare_activities.value": [
      {
        type: 0,
        value: "Verzorgen tanden"
      }
    ],
    zib_ability_to_perform_mouthcare_activities_medical_device,
    zib_ability_to_perform_nursing_activities,
    "zib_ability_to_perform_nursing_activities.focus.value": [
      {
        type: 0,
        value: "Betrokkene"
      }
    ],
    "zib_ability_to_perform_nursing_activities.nursing_intervention.value": [
      {
        type: 0,
        value: "Verpleegkundige interventie"
      }
    ],
    "zib_ability_to_perform_nursing_activities.value": [
      {
        type: 0,
        value: "Verrichten VPK handeling"
      }
    ],
    zib_ability_to_use_toilet,
    "zib_ability_to_use_toilet.menstrual_care.value": [
      {
        type: 0,
        value: "Zorg bij menstruatie"
      }
    ],
    "zib_ability_to_use_toilet.toilet_use.value": [
      {
        type: 0,
        value: "Toiletgebruik"
      }
    ],
    zib_ability_to_wash_one_self,
    "zib_ability_to_wash_one_self.body_part_to_be_bathed.value": [
      {
        type: 0,
        value: "Te wassen lichaamsdeel"
      }
    ],
    "zib_ability_to_wash_one_self.value": [
      {
        type: 0,
        value: "Zich wassen"
      }
    ],
    zib_administration_agreement,
    "zib_administration_agreement.additional_information": [
      {
        type: 0,
        value: "Toedieningsafspraak aanvullende informatie"
      }
    ],
    "zib_administration_agreement.agreement_reason": [
      {
        type: 0,
        value: "Reden afspraak"
      }
    ],
    "zib_administration_agreement.authored_on": [
      {
        type: 0,
        value: "Toedieningsafspraak datum tijd"
      }
    ],
    "zib_administration_agreement.authorizing_prescription": [
      {
        type: 0,
        value: "Medicatieafspraak"
      }
    ],
    "zib_administration_agreement.medication_reference": [
      {
        type: 0,
        value: "Geneesmiddel bij toedienings afspraak"
      }
    ],
    "zib_administration_agreement.medication_treatment": [
      {
        type: 0,
        value: "Medicamenteuze behandeling"
      }
    ],
    "zib_administration_agreement.note": [
      {
        type: 0,
        value: "Toelichting"
      }
    ],
    "zib_administration_agreement.performer": [
      {
        type: 0,
        value: "Verstrekker"
      }
    ],
    "zib_administration_agreement.status": [
      {
        type: 0,
        value: "Geannuleerd indicator"
      }
    ],
    "zib_administration_agreement.usage_duration": [
      {
        type: 0,
        value: "Gebruiksduur"
      }
    ],
    zib_administration_schedule,
    "zib_administration_schedule.repeat.bounds": [
      {
        type: 0,
        value: "Doseerduur"
      }
    ],
    "zib_administration_schedule.repeat.day_of_week": [
      {
        type: 0,
        value: "Weekdagen"
      }
    ],
    "zib_administration_schedule.repeat.duration": [
      {
        type: 0,
        value: "Toedieninsgduur"
      }
    ],
    "zib_administration_schedule.repeat.duration_unit": [
      {
        type: 0,
        value: "Toedieninsgduur"
      }
    ],
    "zib_administration_schedule.repeat.frequency": [
      {
        type: 0,
        value: "Frequentie"
      }
    ],
    "zib_administration_schedule.repeat.frequency_max": [
      {
        type: 0,
        value: "Maximum waarde"
      }
    ],
    "zib_administration_schedule.repeat.period": [
      {
        type: 0,
        value: "Interval"
      }
    ],
    "zib_administration_schedule.repeat.period_unit": [
      {
        type: 0,
        value: "Interval"
      }
    ],
    "zib_administration_schedule.repeat.time_of_day": [
      {
        type: 0,
        value: "Toedientijd"
      }
    ],
    "zib_administration_schedule.repeat.when": [
      {
        type: 0,
        value: "Dagdeel"
      }
    ],
    zib_advance_directive,
    "zib_advance_directive.consenting_party": [
      {
        type: 0,
        value: "Vertegenwoordiger"
      }
    ],
    "zib_advance_directive.date_time": [
      {
        type: 0,
        value: "Wilsverklaring datum"
      }
    ],
    "zib_advance_directive.disorder": [
      {
        type: 0,
        value: "Aandoening"
      }
    ],
    "zib_advance_directive.source": [
      {
        type: 0,
        value: "Wilsverklaring document"
      }
    ],
    "zib_advance_directive.type_of_living_will": [
      {
        type: 0,
        value: "Wilsverklaring type"
      }
    ],
    zib_alcohol_use,
    "zib_alcohol_use.amount.value": [
      {
        type: 0,
        value: "Hoeveelheid"
      }
    ],
    "zib_alcohol_use.comment": [
      {
        type: 0,
        value: "Toelichting"
      }
    ],
    "zib_alcohol_use.effective_period.end": [
      {
        type: 0,
        value: "Stop datum"
      }
    ],
    "zib_alcohol_use.effective_period.start": [
      {
        type: 0,
        value: "Start datum"
      }
    ],
    "zib_alcohol_use.value": [
      {
        type: 0,
        value: "Alcohol gebruik status"
      }
    ],
    "zib_alert.category": [
      {
        type: 0,
        value: "Alert type"
      }
    ],
    "zib_alert.code": [
      {
        type: 0,
        value: "Alert naam"
      }
    ],
    "zib_alert.concern_reference": [
      {
        type: 0,
        value: "Conditie"
      }
    ],
    "zib_alert.period.start": [
      {
        type: 0,
        value: "Begin datum tijd"
      }
    ],
    zib_allergy_intolerance,
    "zib_allergy_intolerance.category.allergie_categorie_codelijst": [
      {
        type: 0,
        value: "Allergie categorie"
      }
    ],
    "zib_allergy_intolerance.clinical_status": [
      {
        type: 0,
        value: "Allergie status"
      }
    ],
    "zib_allergy_intolerance.clinical_status.allergie_status_codelijst": [
      {
        type: 0,
        value: "Allergie status"
      }
    ],
    "zib_allergy_intolerance.code": [
      {
        type: 0,
        value: "Veroorzakende stof"
      }
    ],
    "zib_allergy_intolerance.criticality.critical_extent_codelist": [
      {
        type: 0,
        value: "Mate van kritiek zijn"
      }
    ],
    "zib_allergy_intolerance.identifier": [
      {
        type: 0,
        value: "Identificatie"
      }
    ],
    "zib_allergy_intolerance.last_occurrence": [
      {
        type: 0,
        value: "Laatste reactie datum tijd"
      }
    ],
    "zib_allergy_intolerance.note.author": [
      {
        type: 0,
        value: "Auteur"
      }
    ],
    "zib_allergy_intolerance.note.text": [
      {
        type: 0,
        value: "Toelichting"
      }
    ],
    "zib_allergy_intolerance.onset_date_time": [
      {
        type: 0,
        value: "Begin datum tijd"
      }
    ],
    "zib_allergy_intolerance.patient": [
      {
        type: 0,
        value: "Patiënt"
      }
    ],
    "zib_allergy_intolerance.reaction": [
      {
        type: 0,
        value: "Reactie"
      }
    ],
    "zib_allergy_intolerance.reaction.description": [
      {
        type: 0,
        value: "Reactie beschrijving"
      }
    ],
    "zib_allergy_intolerance.reaction.exposure_route": [
      {
        type: 0,
        value: "Wijze van blootstelling"
      }
    ],
    "zib_allergy_intolerance.reaction.manifestation": [
      {
        type: 0,
        value: "Symptoom"
      }
    ],
    "zib_allergy_intolerance.reaction.onset": [
      {
        type: 0,
        value: "Reactie tijdstip"
      }
    ],
    "zib_allergy_intolerance.reaction.severity": [
      {
        type: 0,
        value: "Ernst"
      }
    ],
    "zib_allergy_intolerance.reaction.substance": [
      {
        type: 0,
        value: "Specifieke stof"
      }
    ],
    "zib_allergy_intolerance.recorder": [
      {
        type: 0,
        value: "Auteur"
      }
    ],
    "zib_allergy_intolerance.verification_status": [
      {
        type: 0,
        value: "Allergie status"
      }
    ],
    "zib_apgar_score.10_minute_appearance_score.value": [
      {
        type: 0,
        value: "Huidskleur score"
      }
    ],
    "zib_apgar_score.10_minute_grimace_score.value": [
      {
        type: 0,
        value: "Reflexen score"
      }
    ],
    "zib_apgar_score.10_minute_muscle_tone_score.value": [
      {
        type: 0,
        value: "Spierspanning score"
      }
    ],
    "zib_apgar_score.10_minute_pulse_score.value": [
      {
        type: 0,
        value: "Hartslag score"
      }
    ],
    "zib_apgar_score.10_minute_respiratory_score.value": [
      {
        type: 0,
        value: "Ademhaling score"
      }
    ],
    "zib_apgar_score.1_minute_appearance_score.value": [
      {
        type: 0,
        value: "Huidskleur score"
      }
    ],
    "zib_apgar_score.1_minute_grimace_score.value": [
      {
        type: 0,
        value: "Reflexen score"
      }
    ],
    "zib_apgar_score.1_minute_muscle_tone_score.value": [
      {
        type: 0,
        value: "Spierspanning score"
      }
    ],
    "zib_apgar_score.1_minute_pulse_score.value": [
      {
        type: 0,
        value: "Hartslag score"
      }
    ],
    "zib_apgar_score.1_minute_respiratory_score.value": [
      {
        type: 0,
        value: "Ademhaling score"
      }
    ],
    "zib_apgar_score.5_minute_appearance_score.value": [
      {
        type: 0,
        value: "Huidskleur score"
      }
    ],
    "zib_apgar_score.5_minute_grimace_score.value": [
      {
        type: 0,
        value: "Reflexen score"
      }
    ],
    "zib_apgar_score.5_minute_muscle_tone_score.value": [
      {
        type: 0,
        value: "Spierspanning score"
      }
    ],
    "zib_apgar_score.5_minute_pulse_score.value": [
      {
        type: 0,
        value: "Hartslag score"
      }
    ],
    "zib_apgar_score.5_minute_respiratory_score.value": [
      {
        type: 0,
        value: "Ademhaling score"
      }
    ],
    "zib_apgar_score.comment": [
      {
        type: 0,
        value: "Toelichting"
      }
    ],
    "zib_apgar_score.effective_date_time": [
      {
        type: 0,
        value: "Apgar score datum tijd"
      }
    ],
    "zib_apgar_score.value": [
      {
        type: 0,
        value: "Apgar score totaal"
      }
    ],
    zib_bladder_function,
    "zib_bladder_function.code": [
      {
        type: 0,
        value: "Blaasfunctie"
      }
    ],
    "zib_bladder_function.comment": [
      {
        type: 0,
        value: "Toelichting"
      }
    ],
    "zib_bladder_function.value": [
      {
        type: 0,
        value: "Urine continentie"
      }
    ],
    zib_blood_pressure,
    "zib_blood_pressure.average_blood_pressure_loinc.value": [
      {
        type: 0,
        value: "Gemiddelde bloeddruk"
      }
    ],
    "zib_blood_pressure.average_blood_pressure_snomed.value": [
      {
        type: 0,
        value: "Gemiddelde bloeddruk"
      }
    ],
    "zib_blood_pressure.body_site": [
      {
        type: 0,
        value: "Meet locatie"
      }
    ],
    "zib_blood_pressure.comment": [
      {
        type: 0,
        value: "Toelichting"
      }
    ],
    "zib_blood_pressure.cuff_type_loinc.value": [
      {
        type: 0,
        value: "Manchet type"
      }
    ],
    "zib_blood_pressure.cuff_type_snomed.value": [
      {
        type: 0,
        value: "Manchet type"
      }
    ],
    "zib_blood_pressure.diastolic_bp.code": [
      {
        type: 0,
        value: "Diastolische bloeddruk"
      }
    ],
    "zib_blood_pressure.diastolic_endpoint.code": [
      {
        type: 0,
        value: "Component test"
      }
    ],
    "zib_blood_pressure.diastolic_endpoint.value": [
      {
        type: 0,
        value: "Diastolisch eindpunt"
      }
    ],
    "zib_blood_pressure.effective": [
      {
        type: 0,
        value: "Bloeddruk datum tijd"
      }
    ],
    "zib_blood_pressure.method": [
      {
        type: 0,
        value: "Meetmethode"
      }
    ],
    "zib_blood_pressure.position_loinc.value": [
      {
        type: 0,
        value: "Houding"
      }
    ],
    "zib_blood_pressure.position_snomed.value": [
      {
        type: 0,
        value: "Houding"
      }
    ],
    "zib_blood_pressure.systolic_bp.value": [
      {
        type: 0,
        value: "Systolische bloeddruk"
      }
    ],
    zib_body_height,
    "zib_body_height.comment": [
      {
        type: 0,
        value: "Toelichting"
      }
    ],
    "zib_body_height.effective": [
      {
        type: 0,
        value: "Lengte datum tijd"
      }
    ],
    "zib_body_height.subject": [
      {
        type: 0,
        value: "Patiënt"
      }
    ],
    "zib_body_height.value": [
      {
        type: 0,
        value: "Lengte waarde"
      }
    ],
    zib_body_temperature,
    "zib_body_temperature.comment": [
      {
        type: 0,
        value: "Toelichting"
      }
    ],
    "zib_body_temperature.effective": [
      {
        type: 0,
        value: "Temperatuur datum tijd"
      }
    ],
    "zib_body_temperature.method": [
      {
        type: 0,
        value: "Temperatuur type"
      }
    ],
    "zib_body_temperature.value": [
      {
        type: 0,
        value: "Temperatuur waarde"
      }
    ],
    zib_body_weight,
    "zib_body_weight.clothing.value": [
      {
        type: 0,
        value: "Kleding"
      }
    ],
    "zib_body_weight.comment": [
      {
        type: 0,
        value: "Toelichting"
      }
    ],
    "zib_body_weight.effective": [
      {
        type: 0,
        value: "Gewicht datum tijd"
      }
    ],
    "zib_body_weight.value": [
      {
        type: 0,
        value: "Gewicht waarde"
      }
    ],
    zib_bowel_function,
    "zib_bowel_function.comment": [
      {
        type: 0,
        value: "Toelichting"
      }
    ],
    "zib_bowel_function.defecation_color.value": [
      {
        type: 0,
        value: "Defecatie kleur"
      }
    ],
    "zib_bowel_function.defecation_consistency.value": [
      {
        type: 0,
        value: "Defecatie consistentie"
      }
    ],
    "zib_bowel_function.fecal_continence.value": [
      {
        type: 0,
        value: "Feces continentie"
      }
    ],
    "zib_bowel_function.frequency.value": [
      {
        type: 0,
        value: "Frequentie"
      }
    ],
    zib_burn_wound,
    "zib_burn_wound.body_site": [
      {
        type: 0,
        value: "Anatomische locatie"
      }
    ],
    "zib_burn_wound.body_site.laterality.value": [
      {
        type: 0,
        value: "Lateraliteit"
      }
    ],
    "zib_burn_wound.code": [
      {
        type: 0,
        value: "Brandwond"
      }
    ],
    "zib_burn_wound.code.burn_type.value": [
      {
        type: 0,
        value: "Brandwond soort"
      }
    ],
    "zib_burn_wound.date_of_last_dressing_change.value": [
      {
        type: 0,
        value: "Datum laatste verbandwissel"
      }
    ],
    "zib_burn_wound.extent.value": [
      {
        type: 0,
        value: "Uitgebreidheid"
      }
    ],
    "zib_burn_wound.note": [
      {
        type: 0,
        value: "Toelichting"
      }
    ],
    "zib_burn_wound.onset": [
      {
        type: 0,
        value: "Ontstaans datum"
      }
    ],
    "zib_burn_wound.stage.summary": [
      {
        type: 0,
        value: "Dieptegraad"
      }
    ],
    zib_burn_wound_extent,
    zib_checklist_pain_behaviour,
    "zib_checklist_pain_behaviour.comment": [
      {
        type: 0,
        value: "Toelichting"
      }
    ],
    "zib_checklist_pain_behaviour.cry.value": [
      {
        type: 0,
        value: "Huilen"
      }
    ],
    "zib_checklist_pain_behaviour.effective_date_time": [
      {
        type: 0,
        value: "Score datum tijd"
      }
    ],
    "zib_checklist_pain_behaviour.eyes.value": [
      {
        type: 0,
        value: "Ogen"
      }
    ],
    "zib_checklist_pain_behaviour.face.value": [
      {
        type: 0,
        value: "Gezicht"
      }
    ],
    "zib_checklist_pain_behaviour.grimace.value": [
      {
        type: 0,
        value: "Grimas"
      }
    ],
    "zib_checklist_pain_behaviour.looking_sad.value": [
      {
        type: 0,
        value: "Verdrietige blik"
      }
    ],
    "zib_checklist_pain_behaviour.moaning.value": [
      {
        type: 0,
        value: "Kreunen"
      }
    ],
    "zib_checklist_pain_behaviour.mouth.value": [
      {
        type: 0,
        value: "Mond"
      }
    ],
    "zib_checklist_pain_behaviour.panic.value": [
      {
        type: 0,
        value: "Paniek"
      }
    ],
    "zib_checklist_pain_behaviour.sounds_of_restlessness.value": [
      {
        type: 0,
        value: "Onrustige geluiden"
      }
    ],
    "zib_checklist_pain_behaviour.tears.value": [
      {
        type: 0,
        value: "Tranen"
      }
    ],
    "zib_checklist_pain_behaviour.value": [
      {
        type: 0,
        value: "Totaal score"
      }
    ],
    zib_comfort_scale,
    "zib_comfort_scale.alertness.value": [
      {
        type: 0,
        value: "Alertheid"
      }
    ],
    "zib_comfort_scale.body_movement.value": [
      {
        type: 0,
        value: "Lichaamsbeweging"
      }
    ],
    "zib_comfort_scale.body_muscle_tone.value": [
      {
        type: 0,
        value: "Spierspanning"
      }
    ],
    "zib_comfort_scale.calmness_agitation.value": [
      {
        type: 0,
        value: "Kalmte_ agitatie"
      }
    ],
    "zib_comfort_scale.comment": [
      {
        type: 0,
        value: "Toelichting"
      }
    ],
    "zib_comfort_scale.crying.value": [
      {
        type: 0,
        value: "Ademhalingsreactie"
      }
    ],
    "zib_comfort_scale.effective_date_time": [
      {
        type: 0,
        value: "Score datum tijd"
      }
    ],
    "zib_comfort_scale.facial_tone.value": [
      {
        type: 0,
        value: "Gezichtsspanning"
      }
    ],
    "zib_comfort_scale.respiratory_response.value": [
      {
        type: 0,
        value: "Ademhalingsreactie"
      }
    ],
    "zib_comfort_scale.value": [
      {
        type: 0,
        value: "Totaal score"
      }
    ],
    zib_contact_information_telecom_type,
    zib_development_child,
    "zib_development_child.age_first_menstruation.value": [
      {
        type: 0,
        value: "Leeftijd eerste menstruatie"
      }
    ],
    "zib_development_child.comment": [
      {
        type: 0,
        value: "Toelichting"
      }
    ],
    "zib_development_child.development_cognition.value": [
      {
        type: 0,
        value: "Ontwikkeling verstandelijk"
      }
    ],
    "zib_development_child.development_linguistics.value": [
      {
        type: 0,
        value: "Ontwikkeling taal"
      }
    ],
    "zib_development_child.development_locomotion.value": [
      {
        type: 0,
        value: "Ontwikkeling motoriek"
      }
    ],
    "zib_development_child.development_social.value": [
      {
        type: 0,
        value: "Ontwikkeling sociaal"
      }
    ],
    "zib_development_child.effective_date_time": [
      {
        type: 0,
        value: "Ontwikkeling kind datum tijd"
      }
    ],
    "zib_development_child.toilet_trainedness_feces.value": [
      {
        type: 0,
        value: "Zindelijkheid feces"
      }
    ],
    "zib_development_child.toilet_trainedness_urine.value": [
      {
        type: 0,
        value: "Zindelijkheid urine"
      }
    ],
    zib_dispense,
    "zib_dispense.additional_information": [
      {
        type: 0,
        value: "Verstrekking aanvullende informatie"
      }
    ],
    "zib_dispense.authorizing_prescription": [
      {
        type: 0,
        value: "Verstrekkingsverzoek"
      }
    ],
    "zib_dispense.days_supply": [
      {
        type: 0,
        value: "Verbruiks duur"
      }
    ],
    "zib_dispense.destination": [
      {
        type: 0,
        value: "Afleverlocatie"
      }
    ],
    "zib_dispense.distribution_form": [
      {
        type: 0,
        value: "Distributievorm"
      }
    ],
    "zib_dispense.medication_reference": [
      {
        type: 0,
        value: "Verstrek geneesmiddel"
      }
    ],
    "zib_dispense.medication_treatment": [
      {
        type: 0,
        value: "Medicamenteuze behandeling"
      }
    ],
    "zib_dispense.note": [
      {
        type: 0,
        value: "Toelichting"
      }
    ],
    "zib_dispense.performer": [
      {
        type: 0,
        value: "Verstrekker"
      }
    ],
    "zib_dispense.quantity": [
      {
        type: 0,
        value: "Verstrekte hoeveelheid"
      }
    ],
    "zib_dispense.request_date": [
      {
        type: 0,
        value: "Aanschrijfdatum"
      }
    ],
    "zib_dispense.when_handed_over": [
      {
        type: 0,
        value: "Verstrekkings datum tijd"
      }
    ],
    zib_dispense_request,
    "zib_dispense_request.additional_wishes": [
      {
        type: 0,
        value: "Aanvullende wensen"
      }
    ],
    "zib_dispense_request.authored_on": [
      {
        type: 0,
        value: "Verstrekkingsverzoek datum"
      }
    ],
    "zib_dispense_request.dispense_request": [
      {
        type: 0,
        value: "Verstrekkingsverzoek"
      }
    ],
    "zib_dispense_request.dispense_request.dispense_location": [
      {
        type: 0,
        value: "Afleverlocatie"
      }
    ],
    "zib_dispense_request.dispense_request.expected_supply_duration": [
      {
        type: 0,
        value: "Duur"
      }
    ],
    "zib_dispense_request.dispense_request.number_of_repeats_allowed": [
      {
        type: 0,
        value: "Aantal herhalingen"
      }
    ],
    "zib_dispense_request.dispense_request.performer": [
      {
        type: 0,
        value: "Beoogd verstrekker"
      }
    ],
    "zib_dispense_request.dispense_request.quantity": [
      {
        type: 0,
        value: "Te verstrekken hoeveelheid"
      }
    ],
    "zib_dispense_request.dispense_request.validity_period": [
      {
        type: 0,
        value: "Verbruiksperiode"
      }
    ],
    "zib_dispense_request.dispense_request.validity_period.end": [
      {
        type: 0,
        value: "Einddatum"
      }
    ],
    "zib_dispense_request.dispense_request.validity_period.start": [
      {
        type: 0,
        value: "Ingangsdatum"
      }
    ],
    "zib_dispense_request.medication_reference": [
      {
        type: 0,
        value: "Geneesmiddel"
      }
    ],
    "zib_dispense_request.medication_treatment": [
      {
        type: 0,
        value: "Medicamenteuze behandeling"
      }
    ],
    "zib_dispense_request.note": [
      {
        type: 0,
        value: "Toelichting"
      }
    ],
    zib_drug_use,
    "zib_drug_use.amount.value": [
      {
        type: 0,
        value: "Hoeveelheid"
      }
    ],
    "zib_drug_use.comment": [
      {
        type: 0,
        value: "Toelichting"
      }
    ],
    "zib_drug_use.drug_or_medication_type.value": [
      {
        type: 0,
        value: "Drugs of geneesmiddel soort"
      }
    ],
    "zib_drug_use.effective_period.end": [
      {
        type: 0,
        value: "Stop datum"
      }
    ],
    "zib_drug_use.effective_period.start": [
      {
        type: 0,
        value: "Start datum"
      }
    ],
    "zib_drug_use.route_of_administration.value": [
      {
        type: 0,
        value: "Toedieningsweg"
      }
    ],
    "zib_drug_use.value": [
      {
        type: 0,
        value: "Drug gebruik status"
      }
    ],
    zib_encounter,
    "zib_encounter.class": [
      {
        type: 0,
        value: "Contact type"
      }
    ],
    "zib_encounter.diagnosis.condition": [
      {
        type: 0,
        value: "Probleem"
      }
    ],
    "zib_encounter.hospitalization.admit_source": [
      {
        type: 0,
        value: "Herkomst"
      }
    ],
    "zib_encounter.hospitalization.discharge_disposition": [
      {
        type: 0,
        value: "Bestemming"
      }
    ],
    "zib_encounter.participant.individual": [
      {
        type: 0,
        value: "Contact met"
      }
    ],
    "zib_encounter.participant.type.health_professional_role": [
      {
        type: 0,
        value: "Zorgverlener rol"
      }
    ],
    "zib_encounter.period.end": [
      {
        type: 0,
        value: "Eind datum tijd"
      }
    ],
    "zib_encounter.period.start": [
      {
        type: 0,
        value: "Begin datum tijd"
      }
    ],
    "zib_encounter.reason": [
      {
        type: 0,
        value: "Afwijkende uitslag"
      }
    ],
    "zib_encounter.reason.text": [
      {
        type: 0,
        value: "Afwijkende uitslag"
      }
    ],
    "zib_encounter.service_provider": [
      {
        type: 0,
        value: "Locatie"
      }
    ],
    zib_family_situation,
    "zib_family_situation.care_responsibility.value": [
      {
        type: 0,
        value: "Zorgtaak"
      }
    ],
    "zib_family_situation.child.value": [
      {
        type: 0,
        value: "Geboortedatum"
      }
    ],
    "zib_family_situation.comment": [
      {
        type: 0,
        value: "Toelichting"
      }
    ],
    "zib_family_situation.family_composition.value": [
      {
        type: 0,
        value: "Gezinssamenstelling"
      }
    ],
    "zib_family_situation.number_of_children.value": [
      {
        type: 0,
        value: "Aantal kinderen"
      }
    ],
    "zib_family_situation.number_of_children_living_at_home.value": [
      {
        type: 0,
        value: "Aantal kinderen inwonend"
      }
    ],
    zib_family_situation_child,
    "zib_family_situation_child.child": [
      {
        type: 0,
        value: "Kind"
      }
    ],
    "zib_family_situation_child.child.contact_person": [
      {
        type: 0,
        value: "Contact persoon"
      }
    ],
    "zib_family_situation_child.child.value": [
      {
        type: 0,
        value: "Geboortedatum"
      }
    ],
    "zib_family_situation_child.comment": [
      {
        type: 0,
        value: "Toelichting"
      }
    ],
    "zib_family_situation_child.family_composition.value": [
      {
        type: 0,
        value: "Gezinssamenstelling"
      }
    ],
    "zib_family_situation_child.number_of_siblings.value": [
      {
        type: 0,
        value: "Aantal kinderen"
      }
    ],
    "zib_family_situation_child.parent_carer.parent_carer": [
      {
        type: 0,
        value: "Ouder verzorger"
      }
    ],
    "zib_family_situation_child.sibling": [
      {
        type: 0,
        value: "Broer of zus"
      }
    ],
    "zib_family_situation_child.sibling.contact_person": [
      {
        type: 0,
        value: "Contactpersoon"
      }
    ],
    "zib_family_situation_child.sibling.value": [
      {
        type: 0,
        value: "Geboortedatum zus broer"
      }
    ],
    zib_family_situation_living_at_home_indicator,
    "zib_family_situation_living_at_home_indicator.value": [
      {
        type: 0,
        value: "Inwonend"
      }
    ],
    zib_feeding_pattern_infant,
    "zib_feeding_pattern_infant.based_on": [
      {
        type: 0,
        value: "Voedingsadvies"
      }
    ],
    "zib_feeding_pattern_infant.comment": [
      {
        type: 0,
        value: "Toelichting"
      }
    ],
    "zib_feeding_pattern_infant.effective_date_time": [
      {
        type: 0,
        value: "Voedingspatroon zuigeling datum tijd"
      }
    ],
    "zib_feeding_pattern_infant.feeding_frequency.value": [
      {
        type: 0,
        value: "Voeding frequentie"
      }
    ],
    "zib_feeding_pattern_infant.feeding_supplement.value": [
      {
        type: 0,
        value: "Voeding toevoeging"
      }
    ],
    "zib_feeding_pattern_infant.feeding_type.feeding_method.value": [
      {
        type: 0,
        value: "Voeding methode"
      }
    ],
    "zib_feeding_pattern_infant.feeding_type.value": [
      {
        type: 0,
        value: "Voeding soort"
      }
    ],
    zib_feeding_tube_system,
    "zib_feeding_tube_system.medical_device": [
      {
        type: 0,
        value: "Medisch hulpmiddel"
      }
    ],
    zib_feeding_tube_system_enteral_nutrition,
    zib_feeding_tube_system_feeding_tube_length,
    zib_flacc_pain_scale,
    "zib_flacc_pain_scale.activity.value": [
      {
        type: 0,
        value: "Activiteit"
      }
    ],
    "zib_flacc_pain_scale.comment": [
      {
        type: 0,
        value: "Toelichting"
      }
    ],
    "zib_flacc_pain_scale.consolability.value": [
      {
        type: 0,
        value: "Troostbaar"
      }
    ],
    "zib_flacc_pain_scale.cry.value": [
      {
        type: 0,
        value: "Huilen"
      }
    ],
    "zib_flacc_pain_scale.effective_date_time": [
      {
        type: 0,
        value: "Score datum tijd"
      }
    ],
    "zib_flacc_pain_scale.face.value": [
      {
        type: 0,
        value: "Gezicht"
      }
    ],
    "zib_flacc_pain_scale.legs.value": [
      {
        type: 0,
        value: "Benen"
      }
    ],
    "zib_flacc_pain_scale.value": [
      {
        type: 0,
        value: "Totaal score"
      }
    ],
    zib_fluid_balance,
    "zib_fluid_balance.comment": [
      {
        type: 0,
        value: "Toelichting"
      }
    ],
    "zib_fluid_balance.effective_period.end": [
      {
        type: 0,
        value: "Vochtbalans stoptijd"
      }
    ],
    "zib_fluid_balance.effective_period.start": [
      {
        type: 0,
        value: "Vochtbalans starttijd"
      }
    ],
    "zib_fluid_balance.fluid_total_in.value": [
      {
        type: 0,
        value: "Vocht totaal in"
      }
    ],
    "zib_fluid_balance.fluid_total_out.value": [
      {
        type: 0,
        value: "Vocht totaal uit"
      }
    ],
    zib_freedom_restricting_measures,
    "zib_freedom_restricting_measures.legal_status": [
      {
        type: 0,
        value: "Juridische status"
      }
    ],
    "zib_freedom_restricting_measures.legally_capable.legally_capable_comment": [
      {
        type: 0,
        value: "Wilsbekwaam toelichting"
      }
    ],
    "zib_freedom_restricting_measures.legally_capable.legally_capable_indicator": [
      {
        type: 0,
        value: "Wilsbekwaam"
      }
    ],
    "zib_freedom_restricting_measures.performed_period.end": [
      {
        type: 0,
        value: "Einde episode"
      }
    ],
    "zib_freedom_restricting_measures.performed_period.start": [
      {
        type: 0,
        value: "Aanvang episode"
      }
    ],
    "zib_freedom_restricting_measures_legally_capable.legally_capable_comment.value": [
      {
        type: 0,
        value: "Wilsbekwaam toelichting"
      }
    ],
    "zib_freedom_restricting_measures_legally_capable.legally_capable_indicator.value": [
      {
        type: 0,
        value: "Wilsbekwaam"
      }
    ],
    zib_freedom_restricting_measures_permission,
    zib_functional_or_mental_status,
    "zib_functional_or_mental_status.code": [
      {
        type: 0,
        value: "Status naam"
      }
    ],
    "zib_functional_or_mental_status.comment": [
      {
        type: 0,
        value: "Toelichting"
      }
    ],
    "zib_functional_or_mental_status.effective_period.start": [
      {
        type: 0,
        value: "Status datum"
      }
    ],
    "zib_functional_or_mental_status.medical_device": [
      {
        type: 0,
        value: "Hulpmiddel"
      }
    ],
    "zib_functional_or_mental_status.subject": [
      {
        type: 0,
        value: "Patiënt"
      }
    ],
    "zib_functional_or_mental_status.value": [
      {
        type: 0,
        value: "Status waarde"
      }
    ],
    "zib_functional_or_mental_status_medical_device.value": [
      {
        type: 0,
        value: "Medisch hulpmiddel"
      }
    ],
    zib_general_measurement,
    "zib_general_measurement.code": [
      {
        type: 0,
        value: "Onderzoek"
      }
    ],
    "zib_general_measurement.comment": [
      {
        type: 0,
        value: "Toelichting"
      }
    ],
    "zib_general_measurement.effective": [
      {
        type: 0,
        value: "Uitslag datum tijd"
      }
    ],
    "zib_general_measurement.method": [
      {
        type: 0,
        value: "Meetmethode"
      }
    ],
    "zib_general_measurement.related": [
      {
        type: 0,
        value: "Meet uitslag"
      }
    ],
    "zib_general_measurement.status.result_status_codelist": [
      {
        type: 0,
        value: "Resultaat status"
      }
    ],
    "zib_general_measurement.value": [
      {
        type: 0,
        value: "Uitslag waarde"
      }
    ],
    zib_head_circumference,
    "zib_head_circumference.comment": [
      {
        type: 0,
        value: "Toelichting"
      }
    ],
    "zib_head_circumference.effective": [
      {
        type: 0,
        value: "Schedelomvang datum tijd"
      }
    ],
    "zib_head_circumference.method": [
      {
        type: 0,
        value: "Schedelomvang meetmethode"
      }
    ],
    "zib_head_circumference.value": [
      {
        type: 0,
        value: "Schedelomvang waarde"
      }
    ],
    zib_hearing_function,
    "zib_hearing_function.comment": [
      {
        type: 0,
        value: "Toelichting"
      }
    ],
    "zib_hearing_function.value": [
      {
        type: 0,
        value: "Hoor functie"
      }
    ],
    zib_hearing_function_hearing_aid,
    "zib_hearing_function_hearing_aid.body_site": [
      {
        type: 0,
        value: "Hulpmiddel anatomische locatie"
      }
    ],
    zib_heart_rate,
    "zib_heart_rate.comment": [
      {
        type: 0,
        value: "Toelichting"
      }
    ],
    "zib_heart_rate.effective": [
      {
        type: 0,
        value: "Hartfrequentie datum tijd"
      }
    ],
    "zib_heart_rate.interpretation": [
      {
        type: 0,
        value: "Hartslag regelmatigheid"
      }
    ],
    "zib_heart_rate.method": [
      {
        type: 0,
        value: "Hartslag meet methode"
      }
    ],
    "zib_heart_rate.value": [
      {
        type: 0,
        value: "Hartfrequentie waarde"
      }
    ],
    "zib_help_from_others.activity": [
      {
        type: 0,
        value: "Hulp van anderen"
      }
    ],
    "zib_help_from_others.activity.detail.category": [
      {
        type: 0,
        value: "Soort hulp"
      }
    ],
    "zib_help_from_others.activity.detail.code": [
      {
        type: 0,
        value: "Aard"
      }
    ],
    "zib_help_from_others.activity.detail.description": [
      {
        type: 0,
        value: "Toelichting"
      }
    ],
    "zib_help_from_others.activity.detail.performer": [
      {
        type: 0,
        value: "Hulpverlener"
      }
    ],
    "zib_help_from_others.activity.detail.scheduled_string": [
      {
        type: 0,
        value: "Frequentie"
      }
    ],
    zib_illness_perception,
    "zib_illness_perception.coping_with_illness_by_family": [
      {
        type: 0,
        value: "Omgaan met ziekteproces door naasten"
      }
    ],
    "zib_illness_perception.coping_with_illness_by_patient": [
      {
        type: 0,
        value: "Omgaan met ziekteproces door patiënt"
      }
    ],
    "zib_illness_perception.patient_illness_insight": [
      {
        type: 0,
        value: "Ziekte inzicht van patiënt"
      }
    ],
    zib_infusion,
    "zib_infusion_administering_system.device.peripheral": [
      {
        type: 0,
        value: "Randapparaat"
      }
    ],
    "zib_infusion_administering_system.note.text": [
      {
        type: 0,
        value: "Toedienings systeem toelichting"
      }
    ],
    zib_infusion_lumen_or_line,
    "zib_infusion_lumen_or_line.administering_system": [
      {
        type: 0,
        value: "Toedienings systeem"
      }
    ],
    "zib_infusion_lumen_or_line.line_status": [
      {
        type: 0,
        value: "Lijn status"
      }
    ],
    "zib_infusion_lumen_or_line.lock_fluid": [
      {
        type: 0,
        value: "Slot vloeistof"
      }
    ],
    "zib_infusion_lumen_or_line.lumen_location": [
      {
        type: 0,
        value: "Lumen locatie"
      }
    ],
    zib_instructions_for_use,
    "zib_instructions_for_use.additional_instruction": [
      {
        type: 0,
        value: "Aanvullende instructie"
      }
    ],
    "zib_instructions_for_use.as_needed_codeable_concept": [
      {
        type: 0,
        value: "Zo nodig"
      }
    ],
    "zib_instructions_for_use.dose": [
      {
        type: 0,
        value: "Keerdosis"
      }
    ],
    "zib_instructions_for_use.max_dose_per_period": [
      {
        type: 0,
        value: "Maximale dosering"
      }
    ],
    "zib_instructions_for_use.rate": [
      {
        type: 0,
        value: "Toedieningssnelheid"
      }
    ],
    "zib_instructions_for_use.route": [
      {
        type: 0,
        value: "Toedieningsweg"
      }
    ],
    "zib_instructions_for_use.sequence": [
      {
        type: 0,
        value: "Volgnummer"
      }
    ],
    "zib_instructions_for_use.text": [
      {
        type: 0,
        value: "Omschrijving"
      }
    ],
    zib_laboratory_test_result_diagnostic_report,
    "zib_laboratory_test_result_diagnostic_report.based_on": [
      {
        type: 0,
        value: "Aanvrager"
      }
    ],
    "zib_laboratory_test_result_diagnostic_report.category.result_type": [
      {
        type: 0,
        value: "Resultaat type"
      }
    ],
    "zib_laboratory_test_result_diagnostic_report.code": [
      {
        type: 0,
        value: "Onderzoek"
      }
    ],
    "zib_laboratory_test_result_diagnostic_report.conclusion": [
      {
        type: 0,
        value: "Uitslag interpretatie en/of toelichting"
      }
    ],
    "zib_laboratory_test_result_diagnostic_report.identifier": [
      {
        type: 0,
        value: "Identificatie"
      }
    ],
    "zib_laboratory_test_result_diagnostic_report.performer.role.health_professional_role": [
      {
        type: 0,
        value: "Zorgverlener rol"
      }
    ],
    "zib_laboratory_test_result_diagnostic_report.specimen": [
      {
        type: 0,
        value: "Monster"
      }
    ],
    "zib_laboratory_test_result_diagnostic_report.status": [
      {
        type: 0,
        value: "Resultaat status"
      }
    ],
    "zib_laboratory_test_result_diagnostic_report.status.result_status": [
      {
        type: 0,
        value: "Resultaat status"
      }
    ],
    zib_laboratory_test_result_observation,
    "zib_laboratory_test_result_observation.based_on": [
      {
        type: 0,
        value: "Aanvrager"
      }
    ],
    "zib_laboratory_test_result_observation.code": [
      {
        type: 0,
        value: "Test code"
      }
    ],
    "zib_laboratory_test_result_observation.comment": [
      {
        type: 0,
        value: "Toelichting"
      }
    ],
    "zib_laboratory_test_result_observation.component": [
      {
        type: 0,
        value: "Laboratorium test"
      }
    ],
    "zib_laboratory_test_result_observation.component.code": [
      {
        type: 0,
        value: "Test code"
      }
    ],
    "zib_laboratory_test_result_observation.component.interpretation": [
      {
        type: 0,
        value: "Interpretatie vlaggen"
      }
    ],
    "zib_laboratory_test_result_observation.component.value": [
      {
        type: 0,
        value: "Test uitslag"
      }
    ],
    "zib_laboratory_test_result_observation.effective": [
      {
        type: 0,
        value: "Test datum tijd"
      }
    ],
    "zib_laboratory_test_result_observation.identifier": [
      {
        type: 0,
        value: "Identificatie"
      }
    ],
    "zib_laboratory_test_result_observation.interpretation.interpretatie_vlaggen_codelijst": [
      {
        type: 0,
        value: "Interpretatie vlaggen"
      }
    ],
    "zib_laboratory_test_result_observation.method": [
      {
        type: 0,
        value: "Testmethode"
      }
    ],
    "zib_laboratory_test_result_observation.reference_range": [
      {
        type: 0,
        value: "Referentie"
      }
    ],
    "zib_laboratory_test_result_observation.reference_range.high": [
      {
        type: 0,
        value: "Referentie bovengrens"
      }
    ],
    "zib_laboratory_test_result_observation.reference_range.low": [
      {
        type: 0,
        value: "Referentie ondergrens"
      }
    ],
    "zib_laboratory_test_result_observation.related": [
      {
        type: 0,
        value: "Gerelateerde uitslag"
      }
    ],
    "zib_laboratory_test_result_observation.result_type": [
      {
        type: 0,
        value: "Resultaat type"
      }
    ],
    "zib_laboratory_test_result_observation.specimen": [
      {
        type: 0,
        value: "Monster"
      }
    ],
    "zib_laboratory_test_result_observation.status": [
      {
        type: 0,
        value: "Test uitslag status"
      }
    ],
    "zib_laboratory_test_result_observation.status.test_result_status": [
      {
        type: 0,
        value: "Test uitslag status"
      }
    ],
    "zib_laboratory_test_result_observation.subject": [
      {
        type: 0,
        value: "Patiënt"
      }
    ],
    "zib_laboratory_test_result_observation.value": [
      {
        type: 0,
        value: "Test uitslag"
      }
    ],
    zib_laboratory_test_result_specimen,
    "zib_laboratory_test_result_specimen.collection.body_site": [
      {
        type: 0,
        value: "Anatomische locatie"
      }
    ],
    "zib_laboratory_test_result_specimen.collection.body_site.morphology": [
      {
        type: 0,
        value: "Morfologie"
      }
    ],
    "zib_laboratory_test_result_specimen.collection.collected_date_time": [
      {
        type: 0,
        value: "Afname datum tijd"
      }
    ],
    "zib_laboratory_test_result_specimen.collection.collected_period": [
      {
        type: 0,
        value: "Verzamelperiode"
      }
    ],
    "zib_laboratory_test_result_specimen.collection.method": [
      {
        type: 0,
        value: "Afnameprocedure"
      }
    ],
    "zib_laboratory_test_result_specimen.collection.quantity": [
      {
        type: 0,
        value: "Verzamelvolume"
      }
    ],
    "zib_laboratory_test_result_specimen.container": [
      {
        type: 0,
        value: "Monstercontainer"
      }
    ],
    "zib_laboratory_test_result_specimen.container.identifier": [
      {
        type: 0,
        value: "Monstervolgnummer"
      }
    ],
    "zib_laboratory_test_result_specimen.container.type": [
      {
        type: 0,
        value: "Containertype"
      }
    ],
    "zib_laboratory_test_result_specimen.identifier": [
      {
        type: 0,
        value: "Monsternummer"
      }
    ],
    "zib_laboratory_test_result_specimen.note": [
      {
        type: 0,
        value: "Toelichting"
      }
    ],
    "zib_laboratory_test_result_specimen.received_time": [
      {
        type: 0,
        value: "Aanname datum tijd"
      }
    ],
    "zib_laboratory_test_result_specimen.subject": [
      {
        type: 0,
        value: "Bron monster"
      }
    ],
    "zib_laboratory_test_result_specimen.type": [
      {
        type: 0,
        value: "Monstermateriaal"
      }
    ],
    zib_laboratory_test_result_specimen_isolate,
    "zib_laboratory_test_result_specimen_isolate.collection.body_site": [
      {
        type: 0,
        value: "Anatomische locatie"
      }
    ],
    "zib_laboratory_test_result_specimen_isolate.collection.body_site.morphology": [
      {
        type: 0,
        value: "Morfologie"
      }
    ],
    "zib_laboratory_test_result_specimen_isolate.collection.collected_date_time": [
      {
        type: 0,
        value: "Afname datum tijd"
      }
    ],
    "zib_laboratory_test_result_specimen_isolate.collection.collected_period": [
      {
        type: 0,
        value: "Verzamelperiode"
      }
    ],
    "zib_laboratory_test_result_specimen_isolate.collection.method": [
      {
        type: 0,
        value: "Afnameprocedure"
      }
    ],
    "zib_laboratory_test_result_specimen_isolate.collection.quantity": [
      {
        type: 0,
        value: "Verzamelvolume"
      }
    ],
    "zib_laboratory_test_result_specimen_isolate.container": [
      {
        type: 0,
        value: "Monstercontainer"
      }
    ],
    "zib_laboratory_test_result_specimen_isolate.container.identifier": [
      {
        type: 0,
        value: "Monstervolgnummer"
      }
    ],
    "zib_laboratory_test_result_specimen_isolate.container.type": [
      {
        type: 0,
        value: "Containertype"
      }
    ],
    "zib_laboratory_test_result_specimen_isolate.identifier": [
      {
        type: 0,
        value: "Monsternummer"
      }
    ],
    "zib_laboratory_test_result_specimen_isolate.note": [
      {
        type: 0,
        value: "Toelichting"
      }
    ],
    "zib_laboratory_test_result_specimen_isolate.received_time": [
      {
        type: 0,
        value: "Aanname datum tijd"
      }
    ],
    "zib_laboratory_test_result_specimen_isolate.subject": [
      {
        type: 0,
        value: "Bron monster"
      }
    ],
    "zib_laboratory_test_result_specimen_isolate.type": [
      {
        type: 0,
        value: "Microorganisme"
      }
    ],
    "zib_laboratory_test_result_substance.code": [
      {
        type: 0,
        value: "Microorganisme"
      }
    ],
    "zib_life_stance.value": [
      {
        type: 0,
        value: "Levensovertuiging"
      }
    ],
    zib_living_situation,
    "zib_living_situation.comment": [
      {
        type: 0,
        value: "Toelichting"
      }
    ],
    "zib_living_situation.value": [
      {
        type: 0,
        value: "Woning type"
      }
    ],
    zib_medical_device,
    "zib_medical_device.body_site": [
      {
        type: 0,
        value: "Anatomische locatie"
      }
    ],
    "zib_medical_device.health_professional": [
      {
        type: 0,
        value: "Zorgverlener"
      }
    ],
    "zib_medical_device.healthcare_provider": [
      {
        type: 0,
        value: "Zorgaanbieder"
      }
    ],
    "zib_medical_device.indication.indication_problem": [
      {
        type: 0,
        value: "Indicatie"
      }
    ],
    "zib_medical_device.note.text": [
      {
        type: 0,
        value: "Toelichting"
      }
    ],
    "zib_medical_device.when_used": [
      {
        type: 0,
        value: "Tijdsduur gedefinieerd door start- en einddatum/tijd"
      }
    ],
    "zib_medical_device.when_used.start": [
      {
        type: 0,
        value: "Begin datum"
      }
    ],
    "zib_medical_device_organization.value": [
      {
        type: 0,
        value: "Zorgaanbieder"
      }
    ],
    "zib_medical_device_practitioner.value": [
      {
        type: 0,
        value: "Zorgverlener"
      }
    ],
    "zib_medical_device_problem.value": [
      {
        type: 0,
        value: "Indicatie"
      }
    ],
    zib_medical_device_product,
    "zib_medical_device_product.identifier": [
      {
        type: 0,
        value: "Product ID"
      }
    ],
    "zib_medical_device_product.note.text": [
      {
        type: 0,
        value: "Product omschrijving"
      }
    ],
    "zib_medical_device_product.type": [
      {
        type: 0,
        value: "Product type"
      }
    ],
    "zib_medical_device_request.code_codeable_concept": [
      {
        type: 0,
        value: "Product type"
      }
    ],
    "zib_medical_device_request.code_reference": [
      {
        type: 0,
        value: "Product"
      }
    ],
    "zib_medical_device_request.occurrence_period.end": [
      {
        type: 0,
        value: "Eind datum"
      }
    ],
    "zib_medical_device_request.occurrence_period.start": [
      {
        type: 0,
        value: "Begin datum"
      }
    ],
    "zib_medical_device_request.performer_type.health_professional_role": [
      {
        type: 0,
        value: "Zorgverlener rol"
      }
    ],
    "zib_medical_device_request.status.order_status": [
      {
        type: 0,
        value: "Order status"
      }
    ],
    zib_medication_administration,
    "zib_medication_administration.agreed_date_time": [
      {
        type: 0,
        value: "Afgesproken datum tijd"
      }
    ],
    "zib_medication_administration.dosage.dose": [
      {
        type: 0,
        value: "Toegediende hoeveelheid"
      }
    ],
    "zib_medication_administration.dosage.rate": [
      {
        type: 0,
        value: "Toedieningssnelheid"
      }
    ],
    "zib_medication_administration.dosage.route": [
      {
        type: 0,
        value: "Toedieningsweg"
      }
    ],
    "zib_medication_administration.double_check_performed": [
      {
        type: 0,
        value: "Dubbele controle uitgevoerd"
      }
    ],
    "zib_medication_administration.effective": [
      {
        type: 0,
        value: "Toedienings datum tijd"
      }
    ],
    "zib_medication_administration.medication_reference": [
      {
        type: 0,
        value: "Product"
      }
    ],
    "zib_medication_administration.medication_treatment": [
      {
        type: 0,
        value: "Medicamenteuze behandeling"
      }
    ],
    "zib_medication_administration.note": [
      {
        type: 0,
        value: "Toelichting"
      }
    ],
    "zib_medication_administration.performer": [
      {
        type: 0,
        value: "Toediener"
      }
    ],
    "zib_medication_administration.status": [
      {
        type: 0,
        value: "Medicatie toediening status"
      }
    ],
    "zib_medication_administration.status.order_status": [
      {
        type: 0,
        value: "Order status"
      }
    ],
    "zib_medication_administration.supporting_information": [
      {
        type: 0,
        value: "Gerelateerde afspraak"
      }
    ],
    "zib_medication_administration_deviating_administration.deviation": [
      {
        type: 0,
        value: "Afwijkende toediening"
      }
    ],
    "zib_medication_administration_deviating_administration.reason_for_deviation": [
      {
        type: 0,
        value: "Medicatie toediening reden van afwijken"
      }
    ],
    zib_medication_agreement,
    "zib_medication_agreement.additional_information": [
      {
        type: 0,
        value: "Medicatieafspraak aanvullende informatie"
      }
    ],
    "zib_medication_agreement.authored_on": [
      {
        type: 0,
        value: "Afspraakdatum"
      }
    ],
    "zib_medication_agreement.medication_reference": [
      {
        type: 0,
        value: "Afgesprokengeneesmiddel"
      }
    ],
    "zib_medication_agreement.medication_treatment": [
      {
        type: 0,
        value: "Medicamenteuze behandeling"
      }
    ],
    "zib_medication_agreement.note": [
      {
        type: 0,
        value: "Toelichting"
      }
    ],
    "zib_medication_agreement.reason_code": [
      {
        type: 0,
        value: "Reden medicatieafspraak"
      }
    ],
    "zib_medication_agreement.reason_reference": [
      {
        type: 0,
        value: "Reden van voorschrijven"
      }
    ],
    "zib_medication_agreement.requester": [
      {
        type: 0,
        value: "Voorschrijver"
      }
    ],
    "zib_medication_agreement.usage_duration": [
      {
        type: 0,
        value: "Duur"
      }
    ],
    zib_medication_period_of_use,
    zib_medication_use,
    "zib_medication_use.as_agreed_indicator": [
      {
        type: 0,
        value: "Volgens afspraak indicator"
      }
    ],
    "zib_medication_use.author": [
      {
        type: 0,
        value: "Auteur"
      }
    ],
    "zib_medication_use.date_asserted": [
      {
        type: 0,
        value: "Registratiedatum"
      }
    ],
    "zib_medication_use.effective_period": [
      {
        type: 0,
        value: "Gebruiksperiode"
      }
    ],
    "zib_medication_use.effective_period.duration": [
      {
        type: 0,
        value: "Tijds duur"
      }
    ],
    "zib_medication_use.effective_period.end": [
      {
        type: 0,
        value: "Einddatum"
      }
    ],
    "zib_medication_use.effective_period.start": [
      {
        type: 0,
        value: "Ingangsdatum"
      }
    ],
    "zib_medication_use.medication_reference": [
      {
        type: 0,
        value: "Gebruiksproduct"
      }
    ],
    "zib_medication_use.medication_treatment": [
      {
        type: 0,
        value: "Medicamenteuze behandeling"
      }
    ],
    "zib_medication_use.note": [
      {
        type: 0,
        value: "Toelichting"
      }
    ],
    "zib_medication_use.prescriber": [
      {
        type: 0,
        value: "Voorschrijver"
      }
    ],
    "zib_medication_use.reason_code.text": [
      {
        type: 0,
        value: "Reden gebruik"
      }
    ],
    "zib_medication_use.reason_for_change_or_discontinuation_of_use": [
      {
        type: 0,
        value: "Reden wijzigen of stoppen gebruik"
      }
    ],
    "zib_medication_use.status": [
      {
        type: 0,
        value: "Medicatie gebruik stop type"
      }
    ],
    "zib_medication_use.taken": [
      {
        type: 0,
        value: "Gebruik indicator"
      }
    ],
    "zib_medication_use_duration.value": [
      {
        type: 0,
        value: "Gebruiksduur"
      }
    ],
    "zib_medication_use_reason_for_change_or_discontinuation_of_use.value": [
      {
        type: 0,
        value: "Reden wijzigen of stoppen gebruik"
      }
    ],
    zib_mobility,
    "zib_mobility.changing_position.value": [
      {
        type: 0,
        value: "Houding veranderen"
      }
    ],
    "zib_mobility.climbing_stairs.value": [
      {
        type: 0,
        value: "Traplopen"
      }
    ],
    "zib_mobility.comment": [
      {
        type: 0,
        value: "Toelichting"
      }
    ],
    "zib_mobility.maintaining_position.value": [
      {
        type: 0,
        value: "Houding handhaven"
      }
    ],
    "zib_mobility.transfer.value": [
      {
        type: 0,
        value: "Uitvoeren transfer"
      }
    ],
    "zib_mobility.walking.value": [
      {
        type: 0,
        value: "Lopen"
      }
    ],
    zib_must_score,
    "zib_must_score.bmi_score.value": [
      {
        type: 0,
        value: "BMI score"
      }
    ],
    "zib_must_score.comment": [
      {
        type: 0,
        value: "Toelichting"
      }
    ],
    "zib_must_score.effective_date_time": [
      {
        type: 0,
        value: "MUST score datum tijd"
      }
    ],
    "zib_must_score.illness_score.value": [
      {
        type: 0,
        value: "Ziekte score"
      }
    ],
    "zib_must_score.value": [
      {
        type: 0,
        value: "Totaal score"
      }
    ],
    "zib_must_score.weight_loss_score.value": [
      {
        type: 0,
        value: "Gewichtsverlies score"
      }
    ],
    zib_nursing_intervention,
    "zib_nursing_intervention.code": [
      {
        type: 0,
        value: "Interventie"
      }
    ],
    "zib_nursing_intervention.frequency": [
      {
        type: 0,
        value: "Frequentie"
      }
    ],
    "zib_nursing_intervention.instruction": [
      {
        type: 0,
        value: "Instructie"
      }
    ],
    "zib_nursing_intervention.note.text": [
      {
        type: 0,
        value: "Toelichting"
      }
    ],
    "zib_nursing_intervention.performed_period.end": [
      {
        type: 0,
        value: "Actie eind datum tijd"
      }
    ],
    "zib_nursing_intervention.performed_period.start": [
      {
        type: 0,
        value: "Actie start datum tijd"
      }
    ],
    "zib_nursing_intervention.performer": [
      {
        type: 0,
        value: "Uitvoerder"
      }
    ],
    "zib_nursing_intervention.performer.role.health_professional_role": [
      {
        type: 0,
        value: "Zorgverlener rol"
      }
    ],
    "zib_nursing_intervention.reason_reference": [
      {
        type: 0,
        value: "Indicatie"
      }
    ],
    "zib_nursing_intervention.requester": [
      {
        type: 0,
        value: "Aanvrager"
      }
    ],
    "zib_nursing_intervention.treatment_objective": [
      {
        type: 0,
        value: "Behandeldoel"
      }
    ],
    zib_nursing_intervention_interval,
    "zib_nursing_intervention_requester.value": [
      {
        type: 0,
        value: "Aanvrager"
      }
    ],
    zib_nutrition_advice,
    "zib_nutrition_advice.comment": [
      {
        type: 0,
        value: "Toelichting"
      }
    ],
    "zib_nutrition_advice.oral_diet.fluid_consistency_type.text": [
      {
        type: 0,
        value: "Consistentie"
      }
    ],
    "zib_nutrition_advice.oral_diet.texture.food_type.text": [
      {
        type: 0,
        value: "Consistentie"
      }
    ],
    "zib_nutrition_advice.oral_diet.texture.modifier.text": [
      {
        type: 0,
        value: "Consistentie"
      }
    ],
    "zib_nutrition_advice.oral_diet.type.text": [
      {
        type: 0,
        value: "Dieet type"
      }
    ],
    "zib_nutrition_advice_explanation.value": [
      {
        type: 0,
        value: "Toelichting"
      }
    ],
    zib_outcome_of_care,
    "zib_outcome_of_care.conclusion": [
      {
        type: 0,
        value: "Zorgresultaat"
      }
    ],
    "zib_outcome_of_care.health_condition": [
      {
        type: 0,
        value: "Gezondheidstoestand"
      }
    ],
    "zib_outcome_of_care.intervention.value": [
      {
        type: 0,
        value: "Interventie"
      }
    ],
    "zib_outcome_of_care.measurement_value": [
      {
        type: 0,
        value: "Meetwaarde"
      }
    ],
    zib_oxygen_saturation,
    "zib_oxygen_saturation.comment": [
      {
        type: 0,
        value: "Toelichting"
      }
    ],
    "zib_oxygen_saturation.effective": [
      {
        type: 0,
        value: "O2 saturatie datum tijd"
      }
    ],
    "zib_oxygen_saturation.extra_oxygen_administration.value": [
      {
        type: 0,
        value: "Extra zuurstof toediening"
      }
    ],
    "zib_oxygen_saturation.value": [
      {
        type: 0,
        value: "Sp o2 waarde"
      }
    ],
    zib_pain_score,
    "zib_pain_score.body_site": [
      {
        type: 0,
        value: "Anatomische locatie"
      }
    ],
    "zib_pain_score.body_site.laterality": [
      {
        type: 0,
        value: "Lateraliteit"
      }
    ],
    "zib_pain_score.comment": [
      {
        type: 0,
        value: "Toelichting"
      }
    ],
    "zib_pain_score.effective_date_time": [
      {
        type: 0,
        value: "Pijnscore datum tijd"
      }
    ],
    "zib_pain_score.method": [
      {
        type: 0,
        value: "Pijn meetmethode"
      }
    ],
    "zib_pain_score.value": [
      {
        type: 0,
        value: "Pijnscore waarde"
      }
    ],
    zib_participation_in_society,
    "zib_participation_in_society.comment": [
      {
        type: 0,
        value: "Toelichting"
      }
    ],
    "zib_participation_in_society.hobby.value": [
      {
        type: 0,
        value: "Vrijetijdsbesteding"
      }
    ],
    "zib_participation_in_society.social_network": [
      {
        type: 0,
        value: "Social network"
      }
    ],
    "zib_participation_in_society.social_network.value": [
      {
        type: 0,
        value: "Sociaal netwerk"
      }
    ],
    "zib_participation_in_society.work_situation.value": [
      {
        type: 0,
        value: "Arbeidssituatie"
      }
    ],
    zib_payer,
    "zib_payer.payor": [
      {
        type: 0,
        value: "Verzekeraar"
      }
    ],
    "zib_payer.payor.bank_information.account_number": [
      {
        type: 0,
        value: "Rekeningnummer"
      }
    ],
    "zib_payer.payor.bank_information.bank_name": [
      {
        type: 0,
        value: "Bank naam"
      }
    ],
    "zib_payer.payor.bank_information.bankcode": [
      {
        type: 0,
        value: "Bankcode"
      }
    ],
    "zib_payer.period.end": [
      {
        type: 0,
        value: "Eind datum tijd"
      }
    ],
    "zib_payer.period.start": [
      {
        type: 0,
        value: "Begin datum tijd"
      }
    ],
    "zib_payer.subscriber_id": [
      {
        type: 0,
        value: "Verzekerde nummer"
      }
    ],
    "zib_payer.type": [
      {
        type: 0,
        value: "Verzekerings soort"
      }
    ],
    zib_payer_bank_information,
    "zib_payer_bank_information.account_number.value": [
      {
        type: 0,
        value: "Rekeningnummer"
      }
    ],
    "zib_payer_bank_information.bank_name.value": [
      {
        type: 0,
        value: "Bank naam"
      }
    ],
    "zib_payer_bank_information.bankcode.value": [
      {
        type: 0,
        value: "Bankcode"
      }
    ],
    zib_pregnancy,
    "zib_pregnancy_date_last_menstruation.value": [
      {
        type: 0,
        value: "Datum laatste menstruatie"
      }
    ],
    "zib_pregnancy_gravidity.value": [
      {
        type: 0,
        value: "Graviditeit"
      }
    ],
    "zib_pregnancy_parity.value": [
      {
        type: 0,
        value: "Pariteit"
      }
    ],
    "zib_pregnancy_pregnancy_duration.value": [
      {
        type: 0,
        value: "Zwangerschapsduur"
      }
    ],
    "zib_pregnancy_pregnancy_status.value": [
      {
        type: 0,
        value: "Zwanger"
      }
    ],
    "zib_pregnancy_term_date.value": [
      {
        type: 0,
        value: "A terme datum"
      }
    ],
    zib_pressure_ulcer,
    "zib_pressure_ulcer.body_site": [
      {
        type: 0,
        value: "Anatomische locatie"
      }
    ],
    "zib_pressure_ulcer.body_site.laterality.value": [
      {
        type: 0,
        value: "Lateraliteit"
      }
    ],
    "zib_pressure_ulcer.code": [
      {
        type: 0,
        value: "Decubitus wond"
      }
    ],
    "zib_pressure_ulcer.date_of_last_dressing_change.value": [
      {
        type: 0,
        value: "Datum laatste verband wissel"
      }
    ],
    "zib_pressure_ulcer.note.text": [
      {
        type: 0,
        value: "Toelichting"
      }
    ],
    "zib_pressure_ulcer.onset": [
      {
        type: 0,
        value: "Ontstaans datum"
      }
    ],
    "zib_pressure_ulcer.stage.summary": [
      {
        type: 0,
        value: "Decubitus categorie"
      }
    ],
    zib_problem,
    "zib_problem.abatement_date_time": [
      {
        type: 0,
        value: "Probleem eind datum"
      }
    ],
    "zib_problem.body_site": [
      {
        type: 0,
        value: "Probleem anatomische locatie"
      }
    ],
    "zib_problem.body_site.laterality": [
      {
        type: 0,
        value: "Probleem lateraliteit"
      }
    ],
    "zib_problem.category": [
      {
        type: 0,
        value: "Probleem type"
      }
    ],
    "zib_problem.clinical_status": [
      {
        type: 0,
        value: "Probleem status"
      }
    ],
    "zib_problem.clinical_status.problem_status_codelist": [
      {
        type: 0,
        value: "Probleemstatus"
      }
    ],
    "zib_problem.code": [
      {
        type: 0,
        value: "Probleem naam"
      }
    ],
    "zib_problem.note": [
      {
        type: 0,
        value: "Toelichting"
      }
    ],
    "zib_problem.onset_date_time": [
      {
        type: 0,
        value: "Probleem begin datum"
      }
    ],
    "zib_problem.verification_status": [
      {
        type: 0,
        value: "Verificatie status"
      }
    ],
    "zib_problem.verification_status.verificatie_status_codelijst": [
      {
        type: 0,
        value: "Verificatie status codelijst"
      }
    ],
    zib_procedure,
    "zib_procedure.body_site": [
      {
        type: 0,
        value: "Verrichting anatomische locatie"
      }
    ],
    "zib_procedure.code": [
      {
        type: 0,
        value: "Verrichting type"
      }
    ],
    "zib_procedure.code.verrichting_type_codelijst": [
      {
        type: 0,
        value: "Verrichting type"
      }
    ],
    "zib_procedure.focal_device.manipulated": [
      {
        type: 0,
        value: "Medisch hulpmiddel"
      }
    ],
    "zib_procedure.performed_period.end": [
      {
        type: 0,
        value: "Verrichting eind datum"
      }
    ],
    "zib_procedure.performed_period.start": [
      {
        type: 0,
        value: "Verrichting start datum"
      }
    ],
    "zib_procedure.performer": [
      {
        type: 0,
        value: "Uitgevoerd door"
      }
    ],
    "zib_procedure.performer.role.health_professional_role": [
      {
        type: 0,
        value: "Zorgverlener rol"
      }
    ],
    "zib_procedure.procedure_method.value": [
      {
        type: 0,
        value: "Verrichting methode"
      }
    ],
    "zib_procedure.reason_reference": [
      {
        type: 0,
        value: "Indicatie"
      }
    ],
    zib_procedure_request,
    "zib_procedure_request.body_site": [
      {
        type: 0,
        value: "Verrichting anatomische locatie"
      }
    ],
    "zib_procedure_request.code": [
      {
        type: 0,
        value: "Verrichting type"
      }
    ],
    "zib_procedure_request.code.verrichting_type_codelijst": [
      {
        type: 0,
        value: "Verrichting type codelijst"
      }
    ],
    "zib_procedure_request.occurrence_period.end": [
      {
        type: 0,
        value: "Eind datum"
      }
    ],
    "zib_procedure_request.occurrence_period.start": [
      {
        type: 0,
        value: "Begin datum"
      }
    ],
    "zib_procedure_request.occurrence_timing.repeat.frequency": [
      {
        type: 0,
        value: "Frequentie"
      }
    ],
    "zib_procedure_request.occurrence_timing.repeat.period": [
      {
        type: 0,
        value: "Interval"
      }
    ],
    "zib_procedure_request.performer": [
      {
        type: 0,
        value: "Uitgevoerd door"
      }
    ],
    "zib_procedure_request.performer_type.health_professional_role": [
      {
        type: 0,
        value: "Zorgverlener rol"
      }
    ],
    "zib_procedure_request.reason_reference": [
      {
        type: 0,
        value: "Indicatie"
      }
    ],
    "zib_procedure_request.requester.agent": [
      {
        type: 0,
        value: "Aangevraagd door"
      }
    ],
    "zib_procedure_request.status.order_status": [
      {
        type: 0,
        value: "Order status"
      }
    ],
    zib_product,
    "zib_product.code.coding": [
      {
        type: 0,
        value: "Product code"
      }
    ],
    "zib_product.code.text": [
      {
        type: 0,
        value: "Product naam"
      }
    ],
    "zib_product.description": [
      {
        type: 0,
        value: "Omschrijving"
      }
    ],
    "zib_product.form": [
      {
        type: 0,
        value: "Farmaceutische vorm"
      }
    ],
    "zib_product.ingredient": [
      {
        type: 0,
        value: "Ingredient"
      }
    ],
    "zib_product.ingredient.amount": [
      {
        type: 0,
        value: "Sterkte"
      }
    ],
    "zib_product.ingredient.amount.denominator": [
      {
        type: 0,
        value: "Product hoeveelheid"
      }
    ],
    "zib_product.ingredient.amount.numerator": [
      {
        type: 0,
        value: "Ingredient hoeveelheid"
      }
    ],
    "zib_product.ingredient.item_codeable_concept": [
      {
        type: 0,
        value: "Ingredient code"
      }
    ],
    zib_pulse_rate,
    "zib_pulse_rate.code": [
      {
        type: 0,
        value: "Polsfrequentie"
      }
    ],
    "zib_pulse_rate.comment": [
      {
        type: 0,
        value: "Toelichting"
      }
    ],
    "zib_pulse_rate.effective": [
      {
        type: 0,
        value: "Polsfrequentie datum tijd"
      }
    ],
    "zib_pulse_rate.pulse_regularity.code": [
      {
        type: 0,
        value: "Component test"
      }
    ],
    "zib_pulse_rate.pulse_regularity.value": [
      {
        type: 0,
        value: "Pols regelmatigheid"
      }
    ],
    "zib_pulse_rate.subject": [
      {
        type: 0,
        value: "Patiënt"
      }
    ],
    "zib_pulse_rate.value": [
      {
        type: 0,
        value: "Polsfrequentie waarde"
      }
    ],
    "zib_respiration.administered_oxygen": [
      {
        type: 0,
        value: "Toegediende zuurstof"
      }
    ],
    "zib_respiration.administered_oxygen.extra_oxygen_administration.value": [
      {
        type: 0,
        value: "Extra zuurstof toediening"
      }
    ],
    "zib_respiration.administered_oxygen.fi_o_2.value": [
      {
        type: 0,
        value: "Fi o2"
      }
    ],
    "zib_respiration.administered_oxygen.flow_rate.value": [
      {
        type: 0,
        value: "Flow rate"
      }
    ],
    "zib_respiration.breathing_frequency.value": [
      {
        type: 0,
        value: "Ademfrequentie"
      }
    ],
    "zib_respiration.comment": [
      {
        type: 0,
        value: "Toelichting"
      }
    ],
    "zib_respiration.depth.value": [
      {
        type: 0,
        value: "Diepte"
      }
    ],
    "zib_respiration.deviating_breathing_pattern.value": [
      {
        type: 0,
        value: "Afwijkend ademhalingspatroon"
      }
    ],
    "zib_respiration.effective_date_time": [
      {
        type: 0,
        value: "Ademhaling datum tijd"
      }
    ],
    "zib_respiration.rhythm.value": [
      {
        type: 0,
        value: "Ritme"
      }
    ],
    zib_respiration_administered_oxygen_administration_device,
    zib_skin_disorder,
    "zib_skin_disorder.body_site": [
      {
        type: 0,
        value: "Anatomische locatie"
      }
    ],
    "zib_skin_disorder.body_site.laterality.value": [
      {
        type: 0,
        value: "Lateraliteit"
      }
    ],
    "zib_skin_disorder.code": [
      {
        type: 0,
        value: "Soort aandoening"
      }
    ],
    "zib_skin_disorder.due_to.value": [
      {
        type: 0,
        value: "Oorzaak"
      }
    ],
    "zib_skin_disorder.note": [
      {
        type: 0,
        value: "Toelichting"
      }
    ],
    zib_sna_qrc_score,
    "zib_sna_qrc_score.appetite_score.value": [
      {
        type: 0,
        value: "Eetlust score"
      }
    ],
    "zib_sna_qrc_score.assisted_eating.value": [
      {
        type: 0,
        value: "Hulp bij eten"
      }
    ],
    "zib_sna_qrc_score.bmi_score.value": [
      {
        type: 0,
        value: "BMI score"
      }
    ],
    "zib_sna_qrc_score.comment": [
      {
        type: 0,
        value: "Toelichting"
      }
    ],
    "zib_sna_qrc_score.effective_date_time": [
      {
        type: 0,
        value: "SNA qrc score datum tijd"
      }
    ],
    "zib_sna_qrc_score.value": [
      {
        type: 0,
        value: "Totaal score"
      }
    ],
    "zib_sna_qrc_score.weight_loss_score.value": [
      {
        type: 0,
        value: "Gewichtsverlies score"
      }
    ],
    zib_snaq_65_plus_score,
    "zib_snaq_65_plus_score.appetite_score.value": [
      {
        type: 0,
        value: "Eetlust score"
      }
    ],
    "zib_snaq_65_plus_score.comment": [
      {
        type: 0,
        value: "Toelichting"
      }
    ],
    "zib_snaq_65_plus_score.effective_date_time": [
      {
        type: 0,
        value: "SNAQ65+score datum tijd"
      }
    ],
    "zib_snaq_65_plus_score.exercise_score.value": [
      {
        type: 0,
        value: "Inspannings score"
      }
    ],
    "zib_snaq_65_plus_score.upperarm_circumference.value": [
      {
        type: 0,
        value: "Bovenarm omtrek score"
      }
    ],
    "zib_snaq_65_plus_score.value": [
      {
        type: 0,
        value: "Totaal score"
      }
    ],
    "zib_snaq_65_plus_score.weight_loss_score.value": [
      {
        type: 0,
        value: "Gewichtsverlies score"
      }
    ],
    zib_snaq_score,
    "zib_snaq_score.appetite_score.value": [
      {
        type: 0,
        value: "Eetlust score"
      }
    ],
    "zib_snaq_score.comment": [
      {
        type: 0,
        value: "Toelichting"
      }
    ],
    "zib_snaq_score.effective_date_time": [
      {
        type: 0,
        value: "SNAQ score datum tijd"
      }
    ],
    "zib_snaq_score.nutrition_score.value": [
      {
        type: 0,
        value: "Voedings score"
      }
    ],
    "zib_snaq_score.value": [
      {
        type: 0,
        value: "Totaal score"
      }
    ],
    "zib_snaq_score.weight_loss_score.value": [
      {
        type: 0,
        value: "Gewichtsverlies score"
      }
    ],
    zib_stoma,
    "zib_stoma.body_site": [
      {
        type: 0,
        value: "Anatomische locatie"
      }
    ],
    "zib_stoma.body_site.laterality": [
      {
        type: 0,
        value: "Lateraliteit"
      }
    ],
    "zib_stoma.comment": [
      {
        type: 0,
        value: "Toelichting"
      }
    ],
    "zib_stoma.effective_date_time": [
      {
        type: 0,
        value: "Aanleg datum"
      }
    ],
    "zib_stoma.value": [
      {
        type: 0,
        value: "Stoma type"
      }
    ],
    zib_strong_kids_score,
    "zib_strong_kids_score.comment": [
      {
        type: 0,
        value: "Toelichting"
      }
    ],
    "zib_strong_kids_score.condition_score.value": [
      {
        type: 0,
        value: "Ziekte beeld score"
      }
    ],
    "zib_strong_kids_score.effective_date_time": [
      {
        type: 0,
        value: "Score datum tijd"
      }
    ],
    "zib_strong_kids_score.nutrition_score.value": [
      {
        type: 0,
        value: "Voedings score"
      }
    ],
    "zib_strong_kids_score.nutrition_status_score.value": [
      {
        type: 0,
        value: "Voedingstoestand score"
      }
    ],
    "zib_strong_kids_score.value": [
      {
        type: 0,
        value: "Totaal score"
      }
    ],
    "zib_strong_kids_score.weight_loss_score.value": [
      {
        type: 0,
        value: "Gewichtsverlies score"
      }
    ],
    zib_text_result,
    "zib_text_result.code": [
      {
        type: 0,
        value: "Onderzoek"
      }
    ],
    "zib_text_result.identifier": [
      {
        type: 0,
        value: "Identificatie"
      }
    ],
    "zib_text_result.performer.role.health_professional_role": [
      {
        type: 0,
        value: "Zorgverlener rol"
      }
    ],
    "zib_text_result.status": [
      {
        type: 0,
        value: "Tekst uitslag status"
      }
    ],
    "zib_text_result.status.text_result_status": [
      {
        type: 0,
        value: "Tekst uitslag status"
      }
    ],
    zib_tobacco_use,
    "zib_tobacco_use.amount.value": [
      {
        type: 0,
        value: "Hoeveelheid"
      }
    ],
    "zib_tobacco_use.comment": [
      {
        type: 0,
        value: "Toelichting"
      }
    ],
    "zib_tobacco_use.effective_period.end": [
      {
        type: 0,
        value: "Stop datum"
      }
    ],
    "zib_tobacco_use.effective_period.start": [
      {
        type: 0,
        value: "Start datum"
      }
    ],
    "zib_tobacco_use.pack_years.value": [
      {
        type: 0,
        value: "Pack years"
      }
    ],
    "zib_tobacco_use.type_of_tobacco_used.value": [
      {
        type: 0,
        value: "Soort tabak gebruik"
      }
    ],
    "zib_tobacco_use.value": [
      {
        type: 0,
        value: "Tabak gebruik status"
      }
    ],
    zib_treatment_directive,
    "zib_treatment_directive.except.restrictions": [
      {
        type: 0,
        value: "Beperkingen"
      }
    ],
    "zib_treatment_directive.period.end": [
      {
        type: 0,
        value: "Eind datum"
      }
    ],
    "zib_treatment_directive.period.start": [
      {
        type: 0,
        value: "Begin datum"
      }
    ],
    "zib_treatment_directive.source": [
      {
        type: 0,
        value: "Wilsverklaring"
      }
    ],
    "zib_treatment_directive.treatment": [
      {
        type: 0,
        value: "Behandeling"
      }
    ],
    "zib_treatment_directive.treatment_permitted": [
      {
        type: 0,
        value: "Behandeling toegestaan"
      }
    ],
    "zib_treatment_directive.verification.verification_date": [
      {
        type: 0,
        value: "Verificatie datum"
      }
    ],
    "zib_treatment_directive.verification.verified": [
      {
        type: 0,
        value: "Geverifieerd"
      }
    ],
    "zib_treatment_directive.verification.verified_with": [
      {
        type: 0,
        value: "Geverifieerd bij"
      }
    ],
    "zib_treatment_directive_treatment.value": [
      {
        type: 0,
        value: "Behandeling"
      }
    ],
    "zib_treatment_directive_treatment_permitted.value": [
      {
        type: 0,
        value: "Behandeling toegestaan"
      }
    ],
    zib_treatment_directive_verification,
    "zib_treatment_directive_verification.verification_date.value": [
      {
        type: 0,
        value: "Verificatie datum"
      }
    ],
    "zib_treatment_directive_verification.verified.value": [
      {
        type: 0,
        value: "Geverifieerd"
      }
    ],
    zib_treatment_objective,
    "zib_treatment_objective.addresses": [
      {
        type: 0,
        value: "Probleem"
      }
    ],
    "zib_treatment_objective.description": [
      {
        type: 0,
        value: "Gewenst zorgresultaat"
      }
    ],
    "zib_treatment_objective.target.detail": [
      {
        type: 0,
        value: "Streefwaarde / gewenste gezondheidstoestand"
      }
    ],
    zib_vaccination,
    "zib_vaccination.date": [
      {
        type: 0,
        value: "Vaccinatie datum"
      }
    ],
    "zib_vaccination.dose_quantity": [
      {
        type: 0,
        value: "Dosis"
      }
    ],
    "zib_vaccination.note.text": [
      {
        type: 0,
        value: "Toelichting"
      }
    ],
    "zib_vaccination.practitioner.actor": [
      {
        type: 0,
        value: "Toediener"
      }
    ],
    "zib_vaccination.practitioner.role.health_professional_role": [
      {
        type: 0,
        value: "Zorgverlener rol"
      }
    ],
    "zib_vaccination.vaccine_code": [
      {
        type: 0,
        value: "Product code"
      }
    ],
    "zib_vaccination_recommendation.order_status": [
      {
        type: 0,
        value: "Order status"
      }
    ],
    "zib_vaccination_recommendation.recommendation.date": [
      {
        type: 0,
        value: "Gewenste datum hervaccinatie"
      }
    ],
    "zib_vaccination_recommendation.recommendation.date_criterion": [
      {
        type: 0,
        value: "Start date"
      }
    ],
    "zib_vaccination_recommendation.recommendation.vaccine_code": [
      {
        type: 0,
        value: "Product code"
      }
    ],
    zib_visual_function,
    "zib_visual_function.comment": [
      {
        type: 0,
        value: "Toelichting"
      }
    ],
    "zib_visual_function.value": [
      {
        type: 0,
        value: "Visuele functie"
      }
    ],
    zib_visual_function_visual_aid,
    zib_wound,
    "zib_wound.body_site": [
      {
        type: 0,
        value: "Anatomische locatie"
      }
    ],
    "zib_wound.body_site.laterality.value": [
      {
        type: 0,
        value: "Lateraliteit"
      }
    ],
    "zib_wound.code": [
      {
        type: 0,
        value: "Wond soort"
      }
    ],
    "zib_wound.note.text": [
      {
        type: 0,
        value: "Toelichting"
      }
    ],
    "zib_wound.onset": [
      {
        type: 0,
        value: "Wond ontstaans datum"
      }
    ]
  };
  const r4ResourceLabels = {
    "r4.nl_core_vaccination_event.dose_quantity": [
      {
        type: 0,
        value: "Dosis"
      }
    ],
    "r4.nl_core_vaccination_event.extra": [
      {
        type: 0,
        value: "Extra informatie"
      }
    ],
    "r4.nl_core_vaccination_event.identifier": [
      {
        type: 0,
        value: "Identificatienummer"
      }
    ],
    "r4.nl_core_vaccination_event.location": [
      {
        type: 0,
        value: "Zorgaanbieder"
      }
    ],
    "r4.nl_core_vaccination_event.note": [
      {
        type: 0,
        value: "Toelichting"
      }
    ],
    "r4.nl_core_vaccination_event.occurrence_date_time": [
      {
        type: 0,
        value: "Gegeven op"
      }
    ],
    "r4.nl_core_vaccination_event.patient": [
      {
        type: 0,
        value: "Naam patient"
      }
    ],
    "r4.nl_core_vaccination_event.performed_by": [
      {
        type: 0,
        value: "Gegeven door"
      }
    ],
    "r4.nl_core_vaccination_event.performer": [
      {
        type: 0,
        value: "Zorgverlener"
      }
    ],
    "r4.nl_core_vaccination_event.pharmaceutical_product": [
      {
        type: 0,
        value: "Inenting"
      }
    ],
    "r4.nl_core_vaccination_event.protocol_applied": [
      {
        type: 0,
        value: "Protocol toegepast"
      }
    ],
    "r4.nl_core_vaccination_event.protocol_applied.authority": [
      {
        type: 0,
        value: "Autoriteit"
      }
    ],
    "r4.nl_core_vaccination_event.protocol_applied.doseNumber": [
      {
        type: 0,
        value: "Dosis nummer"
      }
    ],
    "r4.nl_core_vaccination_event.protocol_applied.seriesDoses": [
      {
        type: 0,
        value: "Serie dosis"
      }
    ],
    "r4.nl_core_vaccination_event.protocol_applied.targetDisease": [
      {
        type: 0,
        value: "Ziekte"
      }
    ],
    "r4.nl_core_vaccination_event.route": [
      {
        type: 0,
        value: "Toedieningsweg"
      }
    ],
    "r4.nl_core_vaccination_event.site": [
      {
        type: 0,
        value: "Lichaamsplek"
      }
    ],
    "r4.nl_core_vaccination_event.status": [
      {
        type: 0,
        value: "Status"
      }
    ],
    "r4.nl_core_vaccination_event.vaccination_indication": [
      {
        type: 0,
        value: "Indicatie"
      }
    ],
    "r4.nl_core_vaccination_event.vaccination_motive": [
      {
        type: 0,
        value: "Aanleiding"
      }
    ],
    "r4.nl_core_vaccination_event.vaccine_code": [
      {
        type: 0,
        value: "Uniek nummer"
      }
    ]
  };
  const messagesNL = {
    ...resourceLabels,
    ...r4ResourceLabels,
    ...fhirMessages
  };
  var Locale = /* @__PURE__ */ ((Locale2) => {
    Locale2["NL_NL"] = "nl-NL";
    return Locale2;
  })(Locale || {});
  const intlCache = {};
  function getIntl(options) {
    const { locale, ignoreMissingTranslations, ignoreIntlCache } = options;
    let intl = ignoreIntlCache ? void 0 : intlCache[locale];
    const onError = (error) => {
      const environment = typeof process !== "undefined" ? process.env.NODE_ENV : "production";
      if (environment !== "test" && environment !== "development") {
        return;
      }
      if (ignoreMissingTranslations && typeof error.message === "string" && error.message.includes("[@formatjs/intl Error MISSING_TRANSLATION]")) {
        return;
      }
      throw error;
    };
    if (!intl) {
      const cache = createIntlCache();
      intl = createIntl(
        {
          locale,
          /**
           * Currently only Dutch is supported
           * We need to figure out how we want to deal with possibly async loading of other languages
           * Especially in the context of the mobile applications
           */
          messages: messagesNL,
          onError
        },
        cache
      );
      intlCache[locale] = intl;
    }
    return intl;
  }
  function toString(value2) {
    if (isNullish(value2)) return;
    return `${value2}`;
  }
  function numberToString(value2) {
    if (isNullish(value2)) return;
    return value2.toString();
  }
  function getChildren(value2) {
    if (isNullish(value2)) return [];
    if (Array.isArray(value2)) {
      return value2.map((x) => x.children).flat();
    }
    return value2.children;
  }
  function isEmptyUiEntry(uiField) {
    switch (uiField.type) {
      case "REFERENCE_VALUE":
        return isNullish(uiField.reference);
      case "SINGLE_VALUE":
        return isNullish(uiField.display);
      case "MULTIPLE_VALUES":
      case "MULTIPLE_GROUPED_VALUES":
        return isNullish(uiField.display) || !uiField.display.flat().length;
      case "DOWNLOAD_LINK":
        return isNullish(uiField.url);
      default:
        throw new Error(`Unknown UI entry type: ${uiField.type}`);
    }
  }
  function processGroup(group, { formatMessage: formatMessage2 }) {
    return {
      ...group,
      children: group.children.map((entry) => {
        return isEmptyUiEntry(entry) ? {
          type: "SINGLE_VALUE",
          label: entry.label,
          display: formatMessage2("schema.empty_entry_display")
        } : entry;
      })
    };
  }
  const setEmptyEntries = (context) => {
    return (schema) => {
      return {
        ...schema,
        children: schema.children.map((x) => processGroup(x, context))
      };
    };
  };
  const multipleValues = ({ intl }) => (label, value2, parse2, options) => {
    let display = void 0;
    if (isNonNullish(value2)) {
      const entries = value2.map((x) => parse2(label, x));
      display = entries.map((x) => x.display).filter(isNonNullish);
    }
    return {
      label: intl.formatMessage({ id: label }),
      type: Array.isArray(display?.[0]) ? "MULTIPLE_GROUPED_VALUES" : "MULTIPLE_VALUES",
      display,
      ...options
    };
  };
  function valueWithUnit$1(value2, unit) {
    if (isNullish(value2)) return;
    const valueString = numberToString(value2);
    if (isNullish(unit)) return valueString;
    return `${valueString} ${unit}`;
  }
  function valueWithMaxValue(value2, maxValue) {
    if (isNullish(value2)) return;
    const valueString = numberToString(value2);
    if (isNullish(maxValue)) return valueString;
    return `${valueString} / ${numberToString(maxValue)}`;
  }
  const value = /* @__PURE__ */ Object.freeze(/* @__PURE__ */ Object.defineProperty({
    __proto__: null,
    valueWithMaxValue,
    valueWithUnit: valueWithUnit$1
  }, Symbol.toStringTag, { value: "Module" }));
  const milliseconds = /T\d\d:\d\d:\d\d\.\d+/i;
  const seconds = /T\d\d:\d\d:\d\d/i;
  const minutes = /T\d\d:\d\d/i;
  const hours = /T\d\d/i;
  const date$3 = /^\d\d\d\d-\d\d-\d\d/;
  const month = /^\d\d\d\d-\d\d/;
  const year = /^\d\d\d\d/;
  const timezone = /(([+-][\d:]+)|Z)$/i;
  function getDateFormatOptions(dateString) {
    const hasMilliseconds = milliseconds.test(dateString);
    const hasSeconds = hasMilliseconds || seconds.test(dateString);
    const hasMinutes = hasSeconds || minutes.test(dateString);
    const hasHours = hasMinutes || hours.test(dateString);
    const hasDate = date$3.test(dateString);
    const hasMonth = hasDate || month.test(dateString);
    const hasYear = hasMonth || year.test(dateString);
    const hasTimezone = hasHours && timezone.test(dateString);
    return {
      year: hasYear ? "numeric" : void 0,
      month: hasMonth ? "long" : void 0,
      day: hasDate ? "numeric" : void 0,
      hour: hasHours ? "numeric" : void 0,
      minute: hasMinutes ? "numeric" : void 0,
      second: hasSeconds ? "numeric" : void 0,
      fractionalSecondDigits: hasMilliseconds ? 3 : void 0,
      timeZoneName: hasTimezone ? "shortOffset" : void 0
    };
  }
  function dateTime$1(value2) {
    if (isNullish(value2)) return;
    const date2 = new Date(value2);
    const dateTimeFormat = new Intl.DateTimeFormat("nl-NL", getDateFormatOptions(value2));
    try {
      return dateTimeFormat.format(date2);
    } catch (_error) {
      return `${value2}`;
    }
  }
  const dateTime$2 = /* @__PURE__ */ Object.freeze(/* @__PURE__ */ Object.defineProperty({
    __proto__: null,
    dateTime: dateTime$1
  }, Symbol.toStringTag, { value: "Module" }));
  function date$1(value2) {
    return dateTime$1(value2);
  }
  const date$2 = /* @__PURE__ */ Object.freeze(/* @__PURE__ */ Object.defineProperty({
    __proto__: null,
    date: date$1
  }, Symbol.toStringTag, { value: "Module" }));
  const format = {
    ...value,
    ...date$2,
    ...dateTime$2
  };
  const valueWithMax = ({ intl }) => (label, value2, max, options) => {
    return {
      label: intl.formatMessage({ id: label }),
      display: format.valueWithMaxValue(value2, max),
      type: "SINGLE_VALUE",
      ...options
    };
  };
  const valueWithUnit = ({ intl }) => (label, value2, unit, options) => {
    return {
      label: intl.formatMessage({ id: label }),
      display: format.valueWithUnit(value2, unit),
      type: "SINGLE_VALUE",
      ...options
    };
  };
  const annotationDisplay = (value2) => {
    return value2?.text;
  };
  const annotation = ({ intl }) => (label, value2, options) => {
    if (Array.isArray(value2)) {
      return {
        label: intl.formatMessage({ id: label }),
        type: "MULTIPLE_VALUES",
        display: value2.map(annotationDisplay).filter(isNonNullish),
        ...options
      };
    }
    return {
      label: intl.formatMessage({ id: label }),
      display: annotationDisplay(value2),
      type: "SINGLE_VALUE",
      ...options
    };
  };
  const boolean = ({ formatMessage: formatMessage2 }) => (label, value2, options) => {
    const truthyString = value2 ? formatMessage2("fhir.boolean.true") : formatMessage2("fhir.boolean.false");
    return {
      label: formatMessage2(label),
      type: "SINGLE_VALUE",
      display: isNonNullish(value2) ? truthyString : void 0,
      ...options
    };
  };
  const code = ({ formatMessage: formatMessage2 }) => (label, value2, options) => {
    if (Array.isArray(value2)) {
      return {
        label: formatMessage2(label),
        type: "MULTIPLE_VALUES",
        display: value2.map(toString).filter(isNonNullish),
        ...options
      };
    }
    return {
      label: formatMessage2(label),
      type: "SINGLE_VALUE",
      display: toString(value2),
      ...options
    };
  };
  const codingDisplay = ({ hasMessage, formatMessage: formatMessage2 }) => (value2) => {
    const { display, code: code2, system } = value2 ?? {};
    let displayString = display ?? "";
    if (code2) {
      const systemI18n = `system.${system}`;
      const systemString = hasMessage(systemI18n) ? formatMessage2(systemI18n) : system;
      const codeInSystemString = formatMessage2("format.code_in_system", {
        code: code2,
        system: systemString
      });
      displayString = `${displayString} (${system ? codeInSystemString : code2})`.trim();
    }
    return displayString === "" ? void 0 : displayString;
  };
  const coding = (context) => (label, value2, options) => {
    const { formatMessage: formatMessage2 } = context;
    const display = codingDisplay(context);
    if (Array.isArray(value2)) {
      return {
        label: formatMessage2(label),
        type: "MULTIPLE_VALUES",
        display: value2.map(display).filter(isNonNullish),
        ...options
      };
    }
    return {
      label: formatMessage2(label),
      type: "SINGLE_VALUE",
      display: display(value2),
      ...options
    };
  };
  const codeableDisplay = (context) => (value2) => {
    if (value2?.text?.length) {
      return [value2.text];
    }
    const coding2 = codingDisplay(context);
    return value2?.coding.map(coding2).filter(isNonNullish) ?? [];
  };
  const codeableConcept = (context) => (label, value2, options) => {
    const { formatMessage: formatMessage2 } = context;
    const display = codeableDisplay(context);
    if (Array.isArray(value2)) {
      return {
        label: formatMessage2(label),
        type: "MULTIPLE_GROUPED_VALUES",
        display: value2.map(display),
        ...options
      };
    }
    return {
      label: formatMessage2(label),
      type: "MULTIPLE_VALUES",
      display: display(value2),
      ...options
    };
  };
  const date = ({ intl }) => (label, value2, options) => {
    return {
      label: intl.formatMessage({ id: label }),
      type: "SINGLE_VALUE",
      display: format.date(value2),
      ...options
    };
  };
  const dateTime = ({ intl }) => (label, value2, options) => {
    if (Array.isArray(value2)) {
      return {
        label: intl.formatMessage({ id: label }),
        type: "MULTIPLE_VALUES",
        display: value2.map(format.dateTime).filter(isNonNullish),
        ...options
      };
    }
    return {
      label: intl.formatMessage({ id: label }),
      type: "SINGLE_VALUE",
      display: format.dateTime(value2),
      ...options
    };
  };
  const codeLabels = {
    "http://unitsofmeasure.org|d": "fhir.duration_days"
    // NOSONAR
  };
  const duration = ({ formatMessage: formatMessage2 }) => (label, value2, options) => {
    const { value: quantityValue, unit, system, code: code2 } = value2 ?? {};
    const codeLabel = codeLabels[`${system}|${code2}`];
    const display = codeLabel ? formatMessage2(codeLabel, { count: quantityValue }) : format.valueWithUnit(quantityValue, unit);
    return {
      label: formatMessage2(label),
      type: `SINGLE_VALUE`,
      display,
      ...options
    };
  };
  const identifier = ({ intl }) => (label, value2, options) => {
    if (Array.isArray(value2)) {
      return {
        label: intl.formatMessage({ id: label }),
        type: "MULTIPLE_VALUES",
        display: value2?.map((x) => x?.value).filter(isNonNullish),
        ...options
      };
    }
    return {
      label: intl.formatMessage({ id: label }),
      type: "SINGLE_VALUE",
      display: value2?.value,
      ...options
    };
  };
  const period = ({ formatMessage: formatMessage2, hasMessage }) => (label, value2, options) => {
    const startLabel = `${label}.start`;
    const endLabel = `${label}.end`;
    return [
      {
        label: formatMessage2(hasMessage(startLabel) ? startLabel : `fhir.period.start`),
        type: `SINGLE_VALUE`,
        display: format.dateTime(value2?.start),
        ...options
      },
      {
        label: formatMessage2(hasMessage(endLabel) ? endLabel : `fhir.period.end`),
        type: `SINGLE_VALUE`,
        display: format.dateTime(value2?.end),
        ...options
      }
    ];
  };
  const quantity = ({ formatMessage: formatMessage2 }) => (label, value2, options) => {
    const { value: quantityValue, unit } = value2 ?? {};
    return {
      label: formatMessage2(label),
      type: `SINGLE_VALUE`,
      display: format.valueWithUnit(quantityValue, unit),
      ...options
    };
  };
  const range = (context) => (label, value2, options) => {
    const { hasMessage, formatMessage: formatMessage2 } = context;
    const lowLabel = `${label}.low`;
    const highLabel = `${label}.high`;
    return [
      {
        label: formatMessage2(hasMessage(lowLabel) ? lowLabel : `fhir.range.low`),
        type: `SINGLE_VALUE`,
        display: format.valueWithUnit(value2?.low?.value, value2?.low?.unit),
        ...options
      },
      {
        label: formatMessage2(hasMessage(highLabel) ? highLabel : `fhir.range.high`),
        type: `SINGLE_VALUE`,
        display: format.valueWithUnit(value2?.high?.value, value2?.high?.unit),
        ...options
      }
    ];
  };
  const ratio = (context) => (label, value2, options) => {
    const { hasMessage, formatMessage: formatMessage2 } = context;
    const numeratorLabel = `${label}.numerator`;
    const denominatorLabel = `${label}.denominator`;
    return [
      {
        label: formatMessage2(
          hasMessage(numeratorLabel) ? numeratorLabel : `fhir.ratio.numerator`
        ),
        type: `SINGLE_VALUE`,
        display: format.valueWithUnit(value2?.numerator?.value, value2?.numerator?.unit),
        ...options
      },
      {
        label: formatMessage2(
          hasMessage(denominatorLabel) ? denominatorLabel : `fhir.ratio.denominator`
        ),
        type: `SINGLE_VALUE`,
        display: format.valueWithUnit(value2?.denominator?.value, value2?.denominator?.unit),
        ...options
      }
    ];
  };
  const reference = ({ intl }) => (label, value2, options) => {
    if (Array.isArray(value2)) {
      return {
        label: intl.formatMessage({ id: label }),
        type: "MULTIPLE_VALUES",
        display: value2.map((x) => x.display).filter(isNonNullish),
        ...options
      };
    }
    return {
      label: intl.formatMessage({ id: label }),
      type: "REFERENCE_VALUE",
      display: value2?.display,
      reference: value2?.reference,
      ...options
    };
  };
  const string = ({ intl }) => (label, value2, options) => {
    if (Array.isArray(value2)) {
      return {
        label: intl.formatMessage({ id: label }),
        type: "MULTIPLE_VALUES",
        display: value2.map(toString).filter(isNonNullish),
        ...options
      };
    }
    return {
      label: intl.formatMessage({ id: label }),
      type: "SINGLE_VALUE",
      display: toString(value2),
      ...options
    };
  };
  const decimal = ({ intl }) => (label, value2, options) => {
    return {
      label: intl.formatMessage({ id: label }),
      type: "SINGLE_VALUE",
      display: numberToString(value2),
      ...options
    };
  };
  const integer = ({ intl }) => (label, value2, options) => {
    return {
      label: intl.formatMessage({ id: label }),
      type: "SINGLE_VALUE",
      display: numberToString(value2),
      ...options
    };
  };
  const integer64 = ({ intl }) => (label, value2, options) => {
    return {
      label: intl.formatMessage({ id: label }),
      type: "SINGLE_VALUE",
      display: numberToString(value2),
      ...options
    };
  };
  const unsignedInt = ({ intl }) => (label, value2, options) => {
    return {
      label: intl.formatMessage({ id: label }),
      type: "SINGLE_VALUE",
      display: numberToString(value2),
      ...options
    };
  };
  const positiveInt = ({ intl }) => (label, value2, options) => {
    return {
      label: intl.formatMessage({ id: label }),
      type: "SINGLE_VALUE",
      display: numberToString(value2),
      ...options
    };
  };
  function getTypes(context) {
    return {
      annotation: annotation(context),
      boolean: boolean(context),
      code: code(context),
      codeableConcept: codeableConcept(context),
      coding: coding(context),
      date: date(context),
      dateTime: dateTime(context),
      duration: duration(context),
      identifier: identifier(context),
      period: period(context),
      quantity: quantity(context),
      range: range(context),
      ratio: ratio(context),
      reference: reference(context),
      string: string(context),
      decimal: decimal(context),
      integer: integer(context),
      integer64: integer64(context),
      unsignedInt: unsignedInt(context),
      positiveInt: positiveInt(context)
    };
  }
  const oneOfValueX = (context) => (label, value2, prefix = "value", options) => {
    if (isNullish(value2)) {
      return [];
    }
    const typeUiFunctions = getTypes(context);
    let type;
    for (type in typeUiFunctions) {
      const key = `${prefix}${capitalizeFirstLetter(type)}`;
      if (key in value2 && isNonNullish(value2[key])) {
        const uiValue = typeUiFunctions[type](label, value2[key], options);
        return Array.isArray(uiValue) ? uiValue : [uiValue];
      }
    }
    return [];
  };
  const downloadLink = (_context) => (value2, options) => {
    return {
      type: "DOWNLOAD_LINK",
      label: value2?.title ?? "",
      url: value2?.url ?? "",
      ...options
    };
  };
  function getSpecial(context) {
    return {
      multipleValues: multipleValues(context),
      valueWithMax: valueWithMax(context),
      valueWithUnit: valueWithUnit(context),
      oneOfValueX: oneOfValueX(context),
      downloadLink: downloadLink()
    };
  }
  function getUi(context) {
    return {
      ...getTypes(context),
      ...getSpecial(context),
      helpers: {
        getChildren
      }
    };
  }
  function createUiSchemaContext(options) {
    const intl = getIntl(options);
    const formatMessage2 = (id, values) => intl.formatMessage({ id }, values);
    const hasMessage = (id) => isNonNullish(intl.messages[id]);
    const uiHelperContext = {
      intl,
      formatMessage: formatMessage2,
      hasMessage
    };
    return {
      ...uiHelperContext,
      ui: getUi(uiHelperContext),
      setEmptyEntries: setEmptyEntries(uiHelperContext)
    };
  }
  function getResourceConfig(resource) {
    const { profile: profile2, fhirVersion } = resource;
    let config;
    if (fhirVersion === FhirVersion.R3) {
      config = resourcesMapR3[profile2];
    } else if (fhirVersion === FhirVersion.R4) {
      config = resourcesMapR4[profile2];
    }
    if (!config) {
      throw new Error(
        `No config found for MGO Resource with profile: "${profile2}" and fhir version: "${fhirVersion}"`
      );
    }
    return config;
  }
  function getUiSchema(resource, options) {
    const config = getResourceConfig(resource);
    const uiSchemaContext = createUiSchemaContext({
      ignoreMissingTranslations: true,
      locale: Locale.NL_NL
    });
    return config.uiSchema(resource, uiSchemaContext);
  }
  function getUiSchemaJson(mgoResourceJson, formatResponse = false) {
    const mgoResource = losslessParse(mgoResourceJson);
    if (!isMgoResource(mgoResource)) {
      throw new Error(
        `input does not seem to be a valid MGO Resource. Received MGO resource profile: "${mgoResource?.profile}"`
      );
    }
    const uiSchema2 = getUiSchema(mgoResource);
    return losslessStringify(uiSchema2, formatResponse);
  }
  exports.getBundleResourcesJson = getBundleResourcesJson;
  exports.getMgoResourceJson = getMgoResourceJson;
  exports.getUiSchemaJson = getUiSchemaJson;
  Object.defineProperty(exports, Symbol.toStringTag, { value: "Module" });
  return exports;
}({});
