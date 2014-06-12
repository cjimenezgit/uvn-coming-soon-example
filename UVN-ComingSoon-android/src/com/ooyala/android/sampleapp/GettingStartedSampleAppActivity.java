package com.ooyala.android.sampleapp;

import java.util.Observable;
import java.util.Observer;

import android.app.Activity;
import android.app.AlertDialog;
import android.content.DialogInterface;
import android.content.DialogInterface.OnClickListener;
import android.os.Bundle;
import android.util.Log;

import com.ooyala.android.AuthorizableItem;
import com.ooyala.android.OoyalaPlayer;
import com.ooyala.android.OoyalaPlayerLayout;
import com.ooyala.android.ui.OoyalaPlayerLayoutController;
import com.ooyala.android.PlayerDomain;

/*
 * This is a modified version of the bundled GettingStartedSample Application in the OoyalaSDK. 
 * It implements the Observer interface to be able to receive notifications of events and respond to them accordingly. 
 * Specifically, it shows how to respond to an asset that's not yet available, showing a pop-up with a "Comming Soon" message. 
 */

public class GettingStartedSampleAppActivity extends Activity implements Observer {

	// Embed code for this example is given for an asset with flight time start date at 04/22/2015. This sample code was written in 2014. 
	// If you're past 2015 or the embed code is no longer valid, you have to provide your own embed code for this to work properly. 
	// Also, remember that the example is only for an asset whose flight time in the future. 
  final String EMBED  = "92YWgybjqtIqp6s9yqAgaHjWqIdVXsJH";  //Embed Code, or Content ID
  final String PCODE  = "R2d3I6s06RyB712DN0_2GsQS-R-Y";
  final String DOMAIN = "http://www.ooyala.com";
  final String TAG = "GettingStartedSampleAppActivity";
  
  public static final String ERROR_NOTIFICATION = "error";
  
  
  OoyalaPlayer player;
  /**
   * Called when the activity is first created.
   */
  @Override
  public void onCreate(Bundle savedInstanceState) {
    super.onCreate(savedInstanceState);
    setContentView(R.layout.main);

    OoyalaPlayerLayout playerLayout = (OoyalaPlayerLayout) findViewById(R.id.ooyalaPlayer);
    OoyalaPlayerLayoutController playerLayoutController = new OoyalaPlayerLayoutController(playerLayout, PCODE, new PlayerDomain(DOMAIN));
    player = playerLayoutController.getPlayer();
    
    // Add the activity as an observer for Player Events. This is mandatory if you want to catch events. 
    player.addObserver(this);
    
    if (player.setEmbedCode(EMBED)) {
      player.play();
    } else {
      Log.d(this.getClass().getName(), "Something Went Wrong!");
    }    
  }

  @Override
  protected void onStop() {
    super.onStop();
    if (player != null) {
      player.suspend();
    }
  }

  @Override
  protected void onRestart() {
    super.onRestart();
    if (player != null) {
      player.resume();
    }
  }
	
	@Override
	// This definition is for the Observer's interface method. 
	public void update(Observable arg0, Object arg1) {
		// arg1 is a String object with the event name. It can be matched to the Constants in OoyalaPlayer. 
		String msg = (String)arg1;
		// OoyalaPlayer emits a set of messages (not all of them are errors) that you can compare to and act accordingly.
		// For this specific example, we only care about the error notification. 
		if(msg == OoyalaPlayer.ERROR_NOTIFICATION){
			// Check more Authorization error codes in http://support.ooyala.com/developers/documentation/concepts/mobile_sdk_android_errors.html
			if(player.getCurrentItem() != null && player.getCurrentItem().getAuthCode() == AuthorizableItem.AuthCode.BEFORE_FLIGHT_TIME){
				yourCodeHere();
			}
		}
	}
	
	// For this example, we display a simple "Comming Soon" dialog box. 
	public void yourCodeHere(){
		AlertDialog.Builder alertDialogBuilder = new AlertDialog.Builder(this);
		alertDialogBuilder.setTitle("Sample feedback window");
		alertDialogBuilder.setMessage("Coming soon");
		alertDialogBuilder.setCancelable(false);
		alertDialogBuilder.setPositiveButton("Yes", new DialogInterface.OnClickListener() {
			@Override
			public void onClick(DialogInterface dialog, int which) {
				// TODO Auto-generated method stub
				dialog.dismiss();
			}
		});
		alertDialogBuilder.setNegativeButton("No", new DialogInterface.OnClickListener() {
			
			@Override
			public void onClick(DialogInterface dialog, int which) {
				// TODO Auto-generated method stub
				dialog.cancel();
			}
		});
		AlertDialog alertDialog = alertDialogBuilder.create();
		alertDialog.show();		
	}
	
}
