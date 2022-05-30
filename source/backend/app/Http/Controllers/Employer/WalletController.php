<?php

namespace App\Http\Controllers\Employer;

use App\Http\Controllers\Controller;
use Illuminate\Http\Request;
use App\CompanyTransactions as CT;
use Auth;
use App\Employer;
use PaytmWallet;

class WalletController extends Controller
{
    public function index(){
        $transactions = CT::where("user_id",Auth::guard("employer")->id())->latest()->paginate(15);
        $employer = Employer::find(Auth::guard("employer")->id());
        return view("employer.wallet.index")->with([
            "transactions"=>$transactions,
            "employer"=>$employer
        ]);
    }
    public function addMoney(Request $request){
        $this->validate($request,[
            "amount"=>"required"
        ]);
        $payment = PaytmWallet::with('receive');
        $id = rand(0,99999).rand(0,99999).rand(0,99999).rand(0,99999).rand(0,99999);
        $employer = Employer::find(Auth::guard("employer")->id());
        $payment->prepare([
          'order' => rand(0,99999),
          'user' => $employer->id,
          'mobile_number' => $employer->phone,
          'email' => $employer->email,
          'amount' => $request->amount,
          'callback_url' => route("employer.wallet.add.done",$request->amount)
        ]);
        return $payment->receive();
    }
    public function doneMoney($amount,Request $request){
        $status = PaytmWallet::with('receive');
        
        $response = $status->response(); // To get raw response as array
        //Check out response parameters sent by paytm here -> http://paywithpaytm.com/developer/paytm_api_doc?target=interpreting-response-sent-by-paytm
        
        if($status->isSuccessful()){
            $employer = Employer::find(Auth::guard("employer")->id());

            $transaction = new CT;
            $transaction->transaction_id = $status->getTransactionId();
            $transaction->user_id = Auth::guard("employer")->id();
            $transaction->type = "INC";
            $transaction->amount = $amount;
            $transaction->reason = "Added money in the wallet";
            $transaction->save();
            $employer->wallet = $employer->wallet + $amount;
            $employer->save();
            $request->session()->flash('success', "Money added to wallet");
            return redirect()->route('employer.wallet');
        }else if($status->isFailed()){
          return "Paytment Failed";
        }else if($status->isOpen()){
            return "Payment Processing";
        }
    }
}
