<?php

namespace App\Http\Controllers\API;

use App\Http\Controllers\Controller;
use Illuminate\Http\Request;
use App\Campaign;
use App\CampaignApp;
use Illuminate\Support\Facades\Auth;
use jazmy\FormBuilder\Helper;
use jazmy\FormBuilder\Models\Form;
use Illuminate\Support\Facades\DB;
use Throwable;

class CampaignController extends Controller
{
    public function list(){
        $campaigns = Campaign::get();
        return response()->json(['response'=>['code'=>'SUCCESS','campaigns'=>$campaigns,'count'=>$campaigns->count()]], 200);
    }
    public function details(Request $request){
        $this->validate($request,[
            'id' => 'required',
        ]);
        $id = $request->id;
        $campaign = Campaign::find($id);
        if($campaign==NULL){
            return response()->json(['response'=>['code'=>'CAMPAIGN NOT FOUND']], 401);
        }
        else{
            $image = asset('assets/admin/img/camp-brand-logo/'.$campaign->logo);
            return response()->json(['response'=>['code'=>'SUCCESS','campaign'=>$campaign,'image'=>$image]], 200);
        }
    }
    public function apply(Request $request){
        $this->validate($request,[
            'id' => 'required',
            'uid' => 'required',
            'terms' => 'required',
        ]);
        $campaignn = Campaign::find($request->id);
        if(CampaignApp::where('cid',$request->id)->get()->count()>=$campaignn->ucount){
            return response()->json(['response'=>['code'=>'APPLY LIMIT HAS EXCEEDED']], 401);
        }
        else{
            $campaign = new CampaignApp;
            $campaign->cid = $request->id;
            $campaign->uid = $request->uid;
            $campaign->status = 0;
            $campaign->save();
            return response()->json(['response'=>['code'=>'SUCCESS']], 200);
        }
    }
    public function proofs(Request $request){
        $this->validate($request,[
            'id' => 'required',
            'cid' => 'required',
            'uid' => 'required',
        ]);
        session()->put('name',$request->id);
        if(CampaignApp::where(['cid'=>$request->cid,'uid' => $request->uid,'status'=>1])->exists()){
            return redirect()->route('campaign.responsera',[$request->cid,$request->uid]);
        }
        else{
            return response()->json(['response'=>['code'=>'CANNOT SUBMIT PROOF TO IT']], 401);
        }
    }
}
