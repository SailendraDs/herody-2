<?php

namespace App\Http\Controllers\Admin;

use App\Gig;
use App\User;
use App\WithdrawRequest;
use Carbon\Carbon;
use Illuminate\Http\Request;
use App\Http\Controllers\Controller;
use Image;
use App\CampaignApp;
use App\ProjectApps;
use App\GigApp;
use Excel;
use App\Exports\AllUsers;
use App\Exports\RefReport;

class MemberManageController extends Controller
{
    public function ShowAllMember()
    {
        $users = User::latest()->paginate(15);
        $serials = $users->firstItem();

        return view('admin.member.all_member',compact('users','serials'));
    }


    public function ShowMemberDetails($id)
    {
        $userById = User::findOrFail($id);
        return view('admin.member.view_member',compact('userById'));
    }

    public function MemberUpdate(Request $request)
    {
         $user = User::findOrFail($request->id);

        $user->name = $request->name;
        $user->phone = $request->phone;
        $user->state = $request->state;
        $user->address = $request->address;
        $user->zip_code = $request->zip_code;


        //image update
        if ($request->hasFile('profile_photo')) {

            //delete old image
            $path = 'assets/user/images/user_profile/';
            $location = $path . $user->profile_photo;
            if (! is_null($user->profile_photo)){
                unlink($location);
            }


            //upload new image
            $input_image = Image::make($request->profile_photo);
            $image = $input_image->resize(224, 235);
            $image_name = $request->file('profile_photo')->getClientOriginalName();
            $image_name = Carbon::now()->format('YmdHs') . '_' . $image_name;
            $image->save($path . $image_name);

            //image update
            $user->profile_photo = $image_name;
        }

        $user->save();

        //redirect
        Session()->flash('success', 'successfully updated!');
        return redirect()->back();
    }

    //WithdrawReport
    public function WithdrawReport($id)
    {
        $withdrawLogs = WithdrawRequest::where('user_id',$id)->paginate(15);
        return view('admin.member.withdraw_report', compact('withdrawLogs'));
    }

    //CampaignReport
    public function CampaignReport($id)
    {
        $acampaigns = CampaignApp::where('uid',$id)->paginate(15);
        return view('admin.member.campaign_report',compact('acampaigns'));
    }

    //Project Report
    public function projectReport($id)
    {
        $aprojects = ProjectApps::where('uid',$id)->paginate(15);
        return view('admin.member.project_report',compact('aprojects'));
    }

    //Gig Report
    public function gigReport($id)
    {
        $agigs = GigApp::where('uid',$id)->paginate(15);
        return view('admin.member.gig_report',compact('agigs'));
    }

    public function pending(){
        $users = User::where('app_status',0)->orderBy('updated_at','asc')->paginate(15);
        return view('admin.member.pending_regs')->with([
            'users' => $users,
        ]);
    }
    public function approve($id){
        $user = User::find($id);
        $user->app_status = 1;
        $user->save();
        Session()->flash('success','Approved User');
        return redirect()->back();
    }
    public function reject($id){
        User::find($id)->delete();
        Session()->flash('success','User Deleted');
        return redirect()->back();
    }
    public function excel_export(){
        $users = User::get();
        if($users->count()==0){
            Session()->flash('warning','No user found');
            return redirect()->back();
        }
        else{
            return Excel::download(new AllUsers(), 'users.xlsx');
        }
    }
    public function excel_referrals(){
        $users = User::get();
        if($users->count()==0){
            Session()->flash('warning','No user found');
            return redirect()->back();
        }
        else{
            return Excel::download(new RefReport(), 'ref_report.xlsx');
        }
    }
}
