package io.trigger.forge.android.modules.barcode;

import io.trigger.forge.android.core.ForgeApp;
import io.trigger.forge.android.core.ForgeIntentResultHandler;
import io.trigger.forge.android.core.ForgeLog;
import io.trigger.forge.android.core.ForgeTask;

import java.util.List;

import com.google.gson.JsonObject;

import android.app.Activity;
import android.app.AlertDialog;
import android.content.ActivityNotFoundException;
import android.content.DialogInterface;
import android.content.Intent;
import android.content.pm.PackageManager;
import android.content.pm.ResolveInfo;
import android.net.Uri;

public class API {
	private static String bs_package = "com.google.zxing.client.android";

	public static void scan(final ForgeTask task) {
		Intent intent = new Intent(bs_package + ".SCAN");
		intent.addCategory(Intent.CATEGORY_DEFAULT);
		intent.setPackage(bs_package);
		intent.addFlags(Intent.FLAG_ACTIVITY_CLEAR_TOP);
		intent.addFlags(Intent.FLAG_ACTIVITY_CLEAR_WHEN_TASK_RESET);
		final PackageManager packageManager = ForgeApp.getActivity().getPackageManager();
		List<ResolveInfo> list = packageManager.queryIntentActivities(intent, PackageManager.MATCH_DEFAULT_ONLY);
		if (list != null && list.size() > 0) {
			// Barcode scanner
			ForgeApp.intentWithHandler(intent, new ForgeIntentResultHandler() {
				@Override
				public void result(int requestCode, int resultCode, Intent data) {
					// Result of scan
					if (resultCode == Activity.RESULT_OK) {
						JsonObject result = new JsonObject();
						result.addProperty("value", data.getStringExtra("SCAN_RESULT"));
						result.addProperty("format", data.getStringExtra("SCAN_RESULT_FORMAT"));
						task.success(result);
					} else if (resultCode == Activity.RESULT_CANCELED) {
						task.error("User cancelled", "EXPECTED_FAILURE", null);
					} else {
						task.error("Unknown error", "UNEXPECTED_FAILURE", null);
					}
				}
			});
		} else {
			// No barcode scanner
			task.performUI(new Runnable() {
				public void run() {					
					AlertDialog.Builder downloadDialog = new AlertDialog.Builder(ForgeApp.getActivity());
					downloadDialog.setTitle("Install Barcode Scanner?");
					downloadDialog.setMessage("This application requires Barcode Scanner. Would you like to install it?");
					downloadDialog.setPositiveButton("Yes", new DialogInterface.OnClickListener() {
						public void onClick(DialogInterface dialogInterface, int i) {
							Uri uri = Uri.parse("market://details?id=" + bs_package);
							Intent intent = new Intent(Intent.ACTION_VIEW, uri);
							try {
								ForgeApp.getActivity().startActivity(intent);
								task.error("Barcode scanner unavailable, opening market for user to install.", "UNAVAILABLE", null);
							} catch (ActivityNotFoundException anfe) {
								ForgeLog.w("Android Market is not installed; cannot install Barcode Scanner");
								task.error("Barcode scanner unavailable", "UNAVAILABLE", null);
							}
						}
					});
					downloadDialog.setNegativeButton("No", new DialogInterface.OnClickListener() {
						public void onClick(DialogInterface dialogInterface, int i) {
							task.error("Barcode scanner unavailable", "UNAVAILABLE", null);
						}
					});			
					downloadDialog.show();
				}
			});
		}
	}
}
