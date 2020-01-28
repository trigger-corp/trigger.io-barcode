package io.trigger.forge.android.modules.barcode;

import android.app.Activity;
import android.content.Intent;

import io.trigger.forge.android.core.ForgeApp;
import io.trigger.forge.android.core.ForgeIntentResultHandler;
import io.trigger.forge.android.core.ForgeLog;
import io.trigger.forge.android.core.ForgeTask;

import com.google.gson.JsonObject;
import com.google.zxing.integration.android.IntentIntegrator;
import com.google.zxing.integration.android.IntentResult;


public class API {

    public static void scan(final ForgeTask task) {
        IntentIntegrator integrator = new IntentIntegrator(ForgeApp.getActivity());

        Intent intent = integrator.createScanIntent();
        ForgeApp.intentWithHandler(intent, new ForgeIntentResultHandler() {
            @Override
            public void result(int requestCode, int resultCode, Intent data) {
                if (resultCode == Activity.RESULT_CANCELED) {
                    task.error("User cancelled", "EXPECTED_FAILURE", null);
                    return;
                }

                IntentResult result = IntentIntegrator.parseActivityResult(resultCode, data);
                if (result == null || result.getContents() == null) {
                    task.error("Unknown error", "UNEXPECTED_FAILURE", null);
                    return;

                }

                JsonObject ret = new JsonObject();
                ret.addProperty("value", result.getContents());
                ret.addProperty("format", result.getFormatName());
                task.success(ret);
            }
        });
    }

}
