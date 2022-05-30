<?php

namespace App\Http\Controllers\Admin;

use App\Http\Controllers\Controller;
use Illuminate\Http\Request;
use App\Withdraw;
use Excel;
use App\Exports\AllWithdrawals;
use App\User;
use App\UserTransaction as UT;

class WithdrawalController extends Controller
{
    public function pending(){
        $withdrawals = Withdraw::where("status",0)->latest()->paginate(15);
        return view("admin.withdraw.pending")->with([
            "withdrawals" => $withdrawals
        ]);
    }
    public function accept(Request $request){
        $this->validate($request,[
            "id"=>"required"
        ]);
        $withdraw = Withdraw::find($request->id);
        if($withdraw===NULL){
            $request->session()->flash('error', "The request does not exist");
            return redirect()->back();
        }
        else{
            $api_key=env('RazorPayKey');
            $api_secret=env('RazorPaySecret');
            $acc=env('RazorPayAccountNumber');
            // Adding payout request
            $details = json_decode($withdraw->details);
            $udata = array(
                "account_number"=>$acc,
                "fund_account_id"=>$details->fund_id,
                "amount"=>$withdraw->amount,
                "mode"=>$withdraw->mode,
                "currency"=>"INR",
                "purpose"=>"refund",
                "queue_if_low_balance"=>TRUE
            );
            $c = curl_init();
            curl_setopt($c, CURLOPT_HTTPHEADER, array('Content-Type: application/json', 'Accept: application/json'));
            \curl_setopt($c,CURLOPT_USERPWD,$api_key.":".$api_secret);
            \curl_setopt($c,CURLOPT_URL,"https://api.razorpay.com/v1/payouts");
            \curl_setopt($c,CURLOPT_POST,1);
            \curl_setopt($c,CURLOPT_RETURNTRANSFER,TRUE);
            \curl_setopt($c,CURLOPT_POSTFIELDS,\json_encode($udata));
            $res = curl_exec($c);
            \curl_close($c);

            $withdraw->status = 1;
            $withdraw->save();

            $request->session()->flash('success', "Request accepted");
            return redirect()->back();
        }
    }
    public function reject(Request $request){
        $this->validate($request,[
            "id"=>"required"
        ]);
        $withdraw = Withdraw::find($request->id);
        if($withdraw===NULL){
            $request->session()->flash('error', "The request does not exist");
            return redirect()->back();
        }
        else{
            $withdraw->status = 2;
            $withdraw->save();
            $user = User::find($withdraw->user_id);
            $user->balance = $user->balance + $withdraw->amount;
            $user->save();
    
            $utransaction = new UT;
            $utransaction->transaction_id = rand(0,99999).rand(0,99999).rand(0,99999).rand(0,99999).rand(0,99999);
            $utransaction->user_id = $user->id;
            $utransaction->type = "INC";
            $utransaction->amount = $withdraw->amount;
            $utransaction->reason = "Withdrawal request rejected";
            $utransaction->save();

            $request->session()->flash('success', "Request rejected");
            return redirect()->back();
        }
    }
    public function approved(){
        $withdrawals = Withdraw::where("status",1)->latest()->paginate(15);
        return view("admin.withdraw.approved")->with([
            "withdrawals" => $withdrawals
        ]);
    }
    public function export_excel(){
        $wrs = Withdraw::get();
        if($wrs->count()==0){
            Session()->flash('warning','No withdrawals found');
            return redirect()->back();
        }
        else{
            return Excel::download(new AllWithdrawals(), 'withdrawals.xlsx');
        }
    }
}
