<?php

namespace App\Http\Controllers\API;

use App\Http\Controllers\Controller;
use Illuminate\Http\Request;
use App\AccDetails;
use Razorpay\Api\Api;
use App\User;

class RazorpayController extends Controller
{
    public function add_contact(request $request)
    {
        $api_key=env('RazorPayKey');
        $api_secret=env('RazorPaySecret');
        $api = new Api($api_key, $api_secret);
        
        $contact = $api->contact->create(array(
            "name"=> $request->name,
            "email"=> $request->email,
            )
          );

        $contact_id=$contact->id;
        if($request->acc_type=='bank_account')
        {
            $fund = $api->fund_account->create(array(
            "contact_id"=>$contact_id,
            "account_type"=>$request->acc_type,
            "bank_account"=>array(
                "name"=>$request->name,
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
        $acc->user_id=$request->id;
        $acc->contact_id=$contact_id;
        $acc->acc_type=$request->acc_type;
        $acc->fund_id=$fund->id;
        $acc->save();
        return response()->json(['response'=>['code'=>'SUCCESS','fund_id'=>$fund->id]], 200);
    }
    public function get_fund_id(Request $req){
        $details=AccDetails::where('user_id',$req->id)->first();
        if($details==NULL){
            return response()->json(['response'=>['code'=>'ERROR','message'=>"There is no account detail with this user id"]], 401);
        }
        else{
            return response()->json(['response'=>['code'=>'SUCCESS','fund_id'=>$details->fund_id]], 200);
        }
    }
    public function withdraw(Request $request){
        $user = User::find($request->id);
        if($user==NULL){
            return response()->json(['response'=>['code'=>'ERROR','message'=>"User does not exist"]], 401);
        }
        else{
            $user->balance = $user->balance - $request->amt;
            $user->save();
            return response()->json(['response'=>['code'=>'SUCCESS']], 200);
        }
    }
}
