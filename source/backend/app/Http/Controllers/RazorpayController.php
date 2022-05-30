<?php

namespace App\Http\Controllers;

use Illuminate\Http\Request;
use App\AccDetails;
use Razorpay\Api\Api;

use Illuminate\Support\Facades\Auth;


class RazorpayController extends Controller
{
    public function create_contact()
    {
        return view('create_account');
    }
    public function add_contact(request $request)
    {
        $api_key=env('RazorPayKey');
        $api_secret=env('RazorPaySecret');
        $api = new Api($api_key, $api_secret);
        
        $contact = $api->contact->create(array(
            "name"=> Auth::user()->name,
            "email"=> Auth::user()->email,
            )
        );
        $contact_id=$contact->id;
        if($request->acc_type=='bank_account')
        {
            $fund = $api->fund_account->create(array(
            "contact_id"=>$contact_id,
            "account_type"=>$request->acc_type,
            "bank_account"=>array(
                "name"=>Auth::user()->name,
                "ifsc"=>$request->ifsc,
                "account_number"=>$request->acc_no
            )
            )
          );
        }
        else{
            $fund = $api->fund_account->create(array(
                "contact_id"=>$contact_id,
                "account_type"=>$request->acc_type,
                "vpa"=>array(
                    "address"=>$request->vpa,
                )
                )
              );
        }
        
        $acc=new AccDetails();
        $acc->user_id=Auth::user()->id;
        $acc->contact_id=$contact_id;
        $acc->acc_type=$request->acc_type;
        $acc->fund_id=$fund->id;
        $acc->save();
        return redirect()->back()->with('success','Fund Account Created Successfully');
    }
    public function givereward($id,$amt)
    {
        $user_id=$id;
        $details=AccDetails::where('user_id',$user_id)->first();
        
        $acc_no=env("RazorPayAccountNumber");
        $api_key=env('RazorPayKey');
        $api_secret=env('RazorPaySecret');
        if($details->acc_type=="bank_account")
        {
            $mode="NEFT";
        }
        else{
            $mode="UPI";
        }
       
        $api = new Api($api_key, $api_secret);
        $contact = $api->payout->create(array(
            "account_number"=> $acc_no,
            "fund_account_id"=> $details->fund_id,
            "amount"=> $amt,
            "currency"=> "INR",
            "mode"=> $mode,
            "purpose"=> "payout",
            
            )
          );
          return redirect()->back();

        
    }
}
