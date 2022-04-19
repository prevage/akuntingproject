/*
	Ractive.js v0.7.3
	Sat Apr 25 2015 13:52:38 GMT-0400 (EDT) - commit da40f81c660ba2f09c45a09a9c20fdd34ee36d80

	http://ractivejs.org
	http://twitter.com/RactiveJS

	Released under the MIT License.
*/

(function (global, factory) {
  typeof exports === 'object' && typeof module !== 'undefined' ? module.exports = factory() :
  typeof define === 'function' && define.amd ? define(factory) :
  global.Ractive = factory()
}(this, function () { 'use strict';

  var TEMPLATE_VERSION = 3;

  var defaultOptions = {

  	// render placement:
  	el: void 0,
  	append: false,

  	// template:
  	template: { v: TEMPLATE_VERSION, t: [] },

  	// parse:     // TODO static delimiters?
  	preserveWhitespace: false,
  	sanitize: false,
  	stripComments: true,
  	delimiters: ["{{", "}}"],
  	tripleDelimiters: ["{{{", "}}}"],
  	interpolate: false,

  	// data & binding:
  	data: {},
  	computed: {},
  	magic: false,
  	modifyArrays: true,
  	adapt: [],
  	isolated: false,
  	twoway: true,
  	lazy: false,

  	// transitions:
  	noIntro: false,
  	transitionsEnabled: true,
  	complete: void 0,

  	// css:
  	css: null,
  	noCssTransform: false
  };

  var config_defaults = defaultOptions;

  // These are a subset of the easing equations found at
  // https://raw.github.com/danro/easing-js - license info
  // follows:

  // --------------------------------------------------
  // easing.js v0.5.4
  // Generic set of easing functions with AMD support
  // https://github.com/danro/easing-js
  // This code may be freely distributed under the MIT license
  // http://danro.mit-license.org/
  // --------------------------------------------------
  // All functions adapted from Thomas Fuchs & Jeremy Kahn
  // Easing Equations (c) 2003 Robert Penner, BSD license
  // https://raw.github.com/danro/easing-js/master/LICENSE
  // --------------------------------------------------

  // In that library, the functions named easeIn, easeOut, and
  // easeInOut below are named easeInCubic, easeOutCubic, and
  // (you guessed it) easeInOutCubic.
  //
  // You can add additional easing functions to this list, and they
  // will be globally available.

  var static_easing = {
  	linear: function (pos) {
  		return pos;
  	},
  	easeIn: function (pos) {
  		return Math.pow(pos, 3);
  	},
  	easeOut: function (pos) {
  		return Math.pow(pos - 1, 3) + 1;
  	},
  	easeInOut: function (pos) {
  		if ((pos /= 0.5) < 1) {
  			return 0.5 * Math.pow(pos, 3);
  		}
  		return 0.5 * (Math.pow(pos - 2, 3) + 2);
  	}
  };

  /*global console, navigator */
  var isClient, isJsdom, hasConsole, environment__magic, namespaces, svg, vendors;

  isClient = typeof document === "object";

  isJsdom = typeof navigator !== "undefined" && /jsDom/.test(navigator.appName);

  hasConsole = typeof console !== "undefined" && typeof console.warn === "function" && typeof console.warn.apply === "function";

  try {
  	Object.defineProperty({}, "test", { value: 0 });
  	environment__magic = true;
  } catch (e) {
  	environment__magic = false;
  }

  namespaces = {
  	html: "http://www.w3.org/1999/xhtml",
  	mathml: "http://www.w3.org/1998/Math/MathML",
  	svg: "http://www.w3.org/2000/svg",
  	xlink: "http://www.w3.org/1999/xlink",
  	xml: "http://www.w3.org/XML/1998/namespace",
  	xmlns: "http://www.w3.org/2000/xmlns/"
  };

  if (typeof document === "undefined") {
  	svg = false;
  } else {
  	svg = document && document.implementation.hasFeature("http://www.w3.org/TR/SVG11/feature#BasicStructure", "1.1");
  }

  vendors = ["o", "ms", "moz", "webkit"];

  var createElement, matches, dom__div, methodNames, unprefixed, prefixed, dom__i, j, makeFunction;

  // Test for SVG support
  if (!svg) {
  	createElement = function (type, ns) {
  		if (ns && ns !== namespaces.html) {
  			throw "This browser does not support namespaces other than http://www.w3.org/1999/xhtml. The most likely cause of this error is that you're trying to render SVG in an older browser. See http://docs.ractivejs.org/latest/svg-and-older-browsers for more information";
  		}

  		return document.createElement(type);
  	};
  } else {
  	createElement = function (type, ns) {
  		if (!ns || ns === namespaces.html) {
  			return document.createElement(type);
  		}

  		return document.createElementNS(ns, type);
  	};
  }

  function getElement(input) {
  	var output;

  	if (!input || typeof input === "boolean") {
  		return;
  	}

  	if (typeof window === "undefined" || !document || !input) {
  		return null;
  	}

  	// We already have a DOM node - no work to do. (Duck typing alert!)
  	if (input.nodeType) {
  		return input;
  	}

  	// Get node from string
  	if (typeof input === "string") {
  		// try ID first
  		output = document.getElementById(input);

  		// then as selector, if possible
  		if (!output && document.querySelector) {
  			output = document.querySelector(input);
  		}

  		// did it work?
  		if (output && output.nodeType) {
  			return output;
  		}
  	}

  	// If we've been given a collection (jQuery, Zepto etc), extract the first item
  	if (input[0] && input[0].nodeType) {
  		return input[0];
  	}

  	return null;
  }

  if (!isClient) {
  	matches = null;
  } else {
  	dom__div = createElement("div");
  	methodNames = ["matches", "matchesSelector"];

  	makeFunction = function (methodName) {
  		return function (node, selector) {
  			return node[methodName](selector);
  		};
  	};

  	dom__i = methodNames.length;

  	while (dom__i-- && !matches) {
  		unprefixed = methodNames[dom__i];

  		if (dom__div[unprefixed]) {
  			matches = makeFunction(unprefixed);
  		} else {
  			j = vendors.length;
  			while (j--) {
  				prefixed = vendors[dom__i] + unprefixed.substr(0, 1).toUpperCase() + unprefixed.substring(1);

  				if (dom__div[prefixed]) {
  					matches = makeFunction(prefixed);
  					break;
  				}
  			}
  		}
  	}

  	// IE8...
  	if (!matches) {
  		matches = function (node, selector) {
  			var nodes, parentNode, i;

  			parentNode = node.parentNode;

  			if (!parentNode) {
  				// empty dummy <div>
  				dom__div.innerHTML = "";

  				parentNode = dom__div;
  				node = node.cloneNode();

  				dom__div.appendChild(node);
  			}

  			nodes = parentNode.querySelectorAll(selector);

  			i = nodes.length;
  			while (i--) {
  				if (nodes[i] === node) {
  					return true;
  				}
  			}

  			return false;
  		};
  	}
  }

  function detachNode(node) {
  	if (node && typeof node.parentNode !== "unknown" && node.parentNode) {
  		node.parentNode.removeChild(node);
  	}

  	return node;
  }

  function safeToStringValue(value) {
  	return value == null || !value.toString ? "" : value;
  }

  var legacy = null;

  var create, defineProperty, defineProperties;

  try {
  	Object.defineProperty({}, "test", { value: 0 });

  	if (isClient) {
  		Object.defineProperty(document.createElement("div"), "test", { value: 0 });
  	}

  	defineProperty = Object.defineProperty;
  } catch (err) {
  	// Object.defineProperty doesn't exist, or we're in IE8 where you can
  	// only use it with DOM objects (what were you smoking, MSFT?)
  	defineProperty = function (obj, prop, desc) {
  		obj[prop] = desc.value;
  	};
  }

  try {
  	try {
  		Object.defineProperties({}, { test: { value: 0 } });
  	} catch (err) {
  		// TODO how do we account for this? noMagic = true;
  		throw err;
  	}

  	if (isClient) {
  		Object.defineProperties(createElement("div"), { test: { value: 0 } });
  	}

  	defineProperties = Object.defineProperties;
  } catch (err) {
  	defineProperties = function (obj, props) {
  		var prop;

  		for (prop in props) {
  			if (props.hasOwnProperty(prop)) {
  				defineProperty(obj, prop, props[prop]);
  			}
  		}
  	};
  }

  try {
  	Object.create(null);

  	create = Object.create;
  } catch (err) {
  	// sigh
  	create = (function () {
  		var F = function () {};

  		return function (proto, props) {
  			var obj;

  			if (proto === null) {
  				return {};
  			}

  			F.prototype = proto;
  			obj = new F();

  			if (props) {
  				Object.defineProperties(obj, props);
  			}

  			return obj;
  		};
  	})();
  }

  function utils_object__extend(target) {
  	for (var _len = arguments.length, sources = Array(_len > 1 ? _len - 1 : 0), _key = 1; _key < _len; _key++) {
  		sources[_key - 1] = arguments[_key];
  	}

  	var prop, source;

  	while (source = sources.shift()) {
  		for (prop in source) {
  			if (hasOwn.call(source, prop)) {
  				target[prop] = source[prop];
  			}
  		}
  	}

  	return target;
  }

  function fillGaps(target) {
  	for (var _len = arguments.length, sources = Array(_len > 1 ? _len - 1 : 0), _key = 1; _key < _len; _key++) {
  		sources[_key - 1] = arguments[_key];
  	}

  	sources.forEach(function (s) {
  		for (var key in s) {
  			if (s.hasOwnProperty(key) && !(key in target)) {
  				target[key] = s[key];
  			}
  		}
  	});

  	return target;
  }

  var hasOwn = Object.prototype.hasOwnProperty;

  // thanks, http://perfectionkills.com/instanceof-considered-harmful-or-how-to-write-a-robust-isarray/
  var is__toString = Object.prototype.toString,
      arrayLikePattern = /^\[object (?:Array|FileList)\]$/;
  function isArray(thing) {
  	return is__toString.call(thing) === "[object Array]";
  }

  function isArrayLike(obj) {
  	return arrayLikePattern.test(is__toString.call(obj));
  }

  function isEqual(a, b) {
  	if (a === null && b === null) {
  		return true;
  	}

  	if (typeof a === "object" || typeof b === "object") {
  		return false;
  	}

  	return a === b;
  }

  function is__isNumeric(thing) {
  	return !isNaN(parseFloat(thing)) && isFinite(thing);
  }

  function isObject(thing) {
  	return thing && is__toString.call(thing) === "[object Object]";
  }

  var noop = function () {};

  /* global console */
  var alreadyWarned = {},
      log,
      printWarning,
      welcome;

  if (hasConsole) {
  	(function () {
  		var welcomeIntro = ["%cRactive.js %c0.7.3 %cin debug mode, %cmore...", "color: rgb(114, 157, 52); font-weight: normal;", "color: rgb(85, 85, 85); font-weight: normal;", "color: rgb(85, 85, 85); font-weight: normal;", "color: rgb(82, 140, 224); font-weight: normal; text-decoration: underline;"];
  		var welcomeMessage = "You're running Ractive 0.7.3 in debug mode - messages will be printed to the console to help you fix problems and optimise your application.\n\nTo disable debug mode, add this line at the start of your app:\n  Ractive.DEBUG = false;\n\nTo disable debug mode when your app is minified, add this snippet:\n  Ractive.DEBUG = /unminified/.test(function(){/*unminified*/});\n\nGet help and support:\n  http://docs.ractivejs.org\n  http://stackoverflow.com/questions/tagged/ractivejs\n  http://groups.google.com/forum/#!forum/ractive-js\n  http://twitter.com/ractivejs\n\nFound a bug? Raise an issue:\n  https://github.com/ractivejs/ractive/issues\n\n";

  		welcome = function () {
  			var hasGroup = !!console.groupCollapsed;
  			console[hasGroup ? "groupCollapsed" : "log"].apply(console, welcomeIntro);
  			console.log(welcomeMessage);
  			if (hasGroup) {
  				console.groupEnd(welcomeIntro);
  			}

  			welcome = noop;
  		};

  		printWarning = function (message, args) {
  			welcome();

  			// extract information about the instance this message pertains to, if applicable
  			if (typeof args[args.length - 1] === "object") {
  				var options = args.pop();
  				var ractive = options ? options.ractive : null;

  				if (ractive) {
  					// if this is an instance of a component that we know the name of, add
  					// it to the message
  					var _name = undefined;
  					if (ractive.component && (_name = ractive.component.name)) {
  						message = "<" + _name + "> " + message;
  					}

  					var node = undefined;
  					if (node = options.node || ractive.fragment && ractive.fragment.rendered && ractive.find("*")) {
  						args.push(node);
  					}
  				}
  			}

  			console.warn.apply(console, ["%cRactive.js: %c" + message, "color: rgb(114, 157, 52);", "color: rgb(85, 85, 85);"].concat(args));
  		};

  		log = function () {
  			console.log.apply(console, arguments);
  		};
  	})();
  } else {
  	printWarning = log = welcome = noop;
  }

  function format(message, args) {
  	return message.replace(/%s/g, function () {
  		return args.shift();
  	});
  }

  function fatal(message) {
  	for (var _len = arguments.length, args = Array(_len > 1 ? _len - 1 : 0), _key = 1; _key < _len; _key++) {
  		args[_key - 1] = arguments[_key];
  	}

  	message = format(message, args);
  	throw new Error(message);
  }

  function logIfDebug() {
  	if (_Ractive.DEBUG) {
  		log.apply(null, a