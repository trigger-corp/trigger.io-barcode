``barcode``: Barcode / QR Code scanner
======================================

>::Note:: ``barcode`` is a premium module so not available during your free trial. To use this module you must upgrade your Project to a paid plan by clicking 'Change plan' on your [account page](https://trigger.io/account).

The ``forge.barcode`` namespace allows the user to scan a barcode or QR code using
the device's camera and returns its content.
	
This module makes use of the [ZXing image processing library](https://code.google.com/p/zxing/). You can read about the support formats on the [project homepage](https://code.google.com/p/zxing/)

##API

!method: forge.barcode.scan(success, error)
!param: success `function(value)` called with the barcode value after a successful scan
!description: Show a UI that allows the user to scan a barcode and return its value.
!platforms: iOS, Android
!param: error `function(content)` called with details of any error which may occur

**Example:**

        forge.barcode.scan(function (value) {
            alert("You scanned: "+value);
        });

!method: forge.barcode.scanWithFormat(success, error)
!param: success `function(barcode)` callback to be invoked when no errors occur - ``barcode`` will contain ``format`` and ``value`` keys, where ``format`` is the barcode type as returned by [ZXing](https://github.com/zxing/zxing)
!description: Show a UI that allows the user to scan a barcode and return its value and type.
!platforms: iOS, Android
!param: error `function(content)` called with details of any error which may occur

**Example:**

	forge.barcode.scanWithFormat(function (barcode) {
		alert("You scanned a: "+barcode.format+": "+barcode.value);
	});
