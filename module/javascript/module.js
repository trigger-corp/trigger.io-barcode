forge['barcode'] = {
	'scan': function (success, error) {
		forge.internal.call("barcode.scan", {}, function (result) {
			success && success(result.value);
		}, error);
	},
	'scanWithFormat': function (success, error) {
		forge.internal.call("barcode.scan", {}, success, error);
	}
};