<?php

namespace App\Http\Controllers\User;
require('assets/textlocal.class.php');

use App\Http\Controllers\Controller;
use Illuminate\Http\Request;

use App\Select;
use App\Reject;
use App\Shortlisted;
use App\Project;
use App\ProjectApps;
use App\CompletedGig;
use App\User;
use App\Withdraw;
use App\WithdrawRequest;
use Illuminate\Support\Facades\Auth;
use Illuminate\Support\Facades\Hash;
use Illuminate\Support\Facades\Session;
use Image;
use App\Skill;
use App\Education;
use App\Experiences;
use App\UserProject;
use App\Certificate;
use App\GigApp as GA;
use Carbon\Carbon;
use App\Transition;
use App\CampaignApp;
use TextLocal;

class DashboardController extends Controller
{
    public function dashboard(){
        $user = Auth::user();
        $exps = Experiences::where('uid',$user->id)->get();
        $skills = Skill::where('uid',$user->id)->get();
        $edus = Education::where('uid',$user->id)->get();
        $projs = UserProject::where('uid',$user->id)->get();
        return view('user.pages.dashboard')->with([
                'user' => $user,
                'exps' => $exps,
                'skills' => $skills,
                'edus' => $edus,
                'projs' => $projs,
            ]
        );
    }
    public function resume(){
        $user = Auth::user();
        $exps = Experiences::where('uid',$user->id)->get();
        $skills = Skill::where('uid',$user->id)->get();
        $edus = Education::where('uid',$user->id)->get();
        $projs = UserProject::where('uid',$user->id)->get();
        $certs = Certificate::where('uid',$user->id)->get();
        return view('user.pages.resume')->with([
                'user' => $user,
                'exps' => $exps,
                'skills' => $skills,
                'edus' => $edus,
                'projs' => $projs,
                'certs' => $certs,
            ]
        );
    }
    public function hobbyUpdate(Request $request){
        $this->validate($request,[
            'hobby' => 'required'
        ]);
        $user = Auth::user();
        $user->hobbies = $request->hobby;
        $user->save();
        Session()->flash('success',"Hobbies added");
        return redirect()->back();
    }
    public function achUpdate(Request $request){
        $this->validate($request,[
            'ach' => 'required'
        ]);
        $user = Auth::user();
        $user->achievements = $request->ach;
        $user->save();
        Session()->flash('success',"Achievements added");
        return redirect()->back();
    }
    public function socialUpdate(Request $request){
        $this->validate($request,[
            'fb' => 'nullable',
            'twitter' => 'nullable',
            'linkedin' => 'nullable',
            'github' => 'nullable',
            'insta' => 'nullable',
        ]);
        $user = Auth::user();
        $user->fb = $request->fb;
        $user->twitter = $request->twitter;
        $user->linkedin = $request->linkedin;
        $user->github = $request->github;
        $user->insta = $request->insta;
        $user->save();
        Session()->flash('success',"Social added");
        return redirect()->back();
    }

    public function eduUpdate(Request $request){
        $this->validate($request,[
            'type' => "required",
            'name' => "required",
            'course' => "required",
            'start' => "required",
            'end' => "required",
        ]);
        $uid = Auth::user()->id;
        $edu = new Education;
        $edu->type = $request->type;
        $edu->name = $request->name;
        $edu->course = $request->course;
        $edu->start = $request->start;
        $edu->end = $request->end;
        $edu->uid = $uid;
        $edu->save();
        Session()->flash('success',"Education Details added");
        return redirect()->back();
    }
    public function expUpdate(Request $request){
        $this->validate($request,[
            'company' => "required",
            'designation' => "required",
            'des' => "required",
            'start' => "required",
            'end' => "required",
        ]);
        $uid = Auth::user()->id;
        $exp = new Experiences;
        $exp->company = $request->company;
        $exp->designation = $request->designation;
        $exp->des = $request->des;
        $exp->start = $request->start;
        $exp->end = $request->end;
        $exp->uid = $uid;
        $exp->save();
        Session()->flash('success',"Work Experience Detail added");
        return redirect()->back();
    }
    public function projUpdate(Request $request){
        $this->validate($request,[
            'title' => "required",
            'projdes' => "required",
        ]);
        $uid = Auth::user()->id;
        $proj = new UserProject;
        $proj->title = $request->title;
        $proj->des = $request->projdes;
        $proj->uid = $uid;
        $proj->save();
        Session()->flash('success',"Project added");
        return redirect()->back();
    }
    public function skillUpdate(Request $request){
        $this->validate($request,[
            'name' => "required",
            'rating' => "required",
        ]);
        $uid = Auth::user()->id;
        $skill = new Skill;
        $skill->name = $request->name;
        $skill->rating = $request->rating;
        $skill->uid = $uid;
        $skill->save();
        Session()->flash('success',"Skill added");
        return redirect()->back();
    }

    public function eduDelete($id){
        $edu = Education::find($id);
        if($edu->uid!=Auth::user()->id){
            return redirect()->back();
        }
        else{
            $edu->delete();
            Session()->flash('success',"Education detail deleted");
            return redirect()->back();
        }
    }
    public function expDelete($id){
        $exp = Experiences::find($id);
        if($exp->uid!=Auth::user()->id){
            return redirect()->back();
        }
        else{
            $exp->delete();
            Session()->flash('success',"Experience detail deleted");
            return redirect()->back();
        }
    }
    public function projDelete($id){
        $exp = UserProject::find($id);
        if($exp->uid!=Auth::user()->id){
            return redirect()->back();
        }
        else{
            $exp->delete();
            Session()->flash('success',"Porject detail deleted");
            return redirect()->back();
        }
    }
    public function skillDelete($id){
        $exp = Skill::find($id);
        if($exp->uid!=Auth::user()->id){
            return redirect()->back();
        }
        else{
            $exp->delete();
            Session()->flash('success',"Skill detail deleted");
            return redirect()->back();
        }
    }
    public function profile()
    {
        $user = Auth::user();
        $exps = Experiences::where('uid',$user->id)->get();
        $skills = Skill::where('uid',$user->id)->get();
        $edus = Education::where('uid',$user->id)->get();
        $projs = UserProject::where('uid',$user->id)->get();
        return view('user.pages.profile', compact('user'))->with([
                'exps' => $exps,
                'skills' => $skills,
                'edus' => $edus,
                'projs' => $projs,
            ]
        );
    }

    //user profile update
    public function updateProfile(Request $request)
    {

        //validation
        $this->validate($request, [
            'profile_photo' => 'image',
        ]);

        $user = User::find(Auth::user()->id);


        $user->name = $request->name;
        $user->state = $request->state;
        $user->city = $request->city;
        $user->address = $request->address;
        $user->about = $request->about;

        $user->phone = $request->phone;
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
        Session()->flash('success', 'Profile successfully updated!');
        return redirect()->back();

    }


    //change password
    public function changepwr()
    {
        $user = Auth::user();
        return view('user.pages.changepw', compact('user'));
    }
    public function logout(){
        Auth::logout();
        return redirect()->route('login');
    }

    //password update
    public function updatePassword(Request $request)
    {
        //validation
        $this->validate($request, [
            'current_password' => 'required',
            'password' => 'required|min:5|confirmed'
        ]);

        $UserPassword = Auth::user()->password;

        if (password_verify($request->current_password, $UserPassword)) {

            //update query
            $userId = Auth::id();

            $user = User::find($userId);

            $user->password = Hash::make($request->password);
            $user->save();

            //redirect
            Session()->flash('success', 'Password successfully Changes!');
            return redirect()->back();
        } else {
            //redirect
            Session()->flash('warning', 'Please enter correct password!');
            return redirect()->back();

        }
    }
    public function projects()
    {
        $jobas = ProjectApps::where('uid', Auth::id())->latest()->paginate(20);
        return view('user.pages.projects', compact('jobas'));
    }
    public function gigs()
    {
        $finishedTask = GA::where('uid', Auth::id())->latest()->paginate(10);
        return view('user.pages.gigs', compact('finishedTask'));
    }

    // Withdraws
    public function ShowWithdrawMethod()
    {
        $withdrawMethods = Withdraw::get();
        $trs = Transition::where('uid',Auth::user()->id)->orderBy('created_at','desc')->paginate(5);

        $user = Auth::user();
        return view('user.pages.withdrawMethod', compact('withdrawMethods'))->with([
            'user'=>$user,
            'trs'=>$trs,
        ]);
    }

    public function ShowWithdrawLog()
    {
        $withdrawLogs = WithdrawRequest::where('user_id',Auth::id())->paginate(10);
        return view('user.pages.withdraw_history', compact('withdrawLogs'));
    }


    public function WithdrawPreview(Request $request)
    {
        $request_withdrawAmount = $request->withdrawAmount;
        $withdrawMethods = Withdraw::find($request->methodId);

        //check balance availability
        if (Auth::user()->balance < $request_withdrawAmount){
            Session()->flash('warning', 'You do not have sufficient balance !');
            return redirect()->back();
        }
        

        $withdraw_method_id = $request->methodId;
        return view('user.pages.withdrawPreview', compact('withdrawMethods', 'request_withdrawAmount', 'withdraw_method_id'));
    }

    public function WithdrawConfirm(Request $request)
    {
        //charge form user account
        $user_balance = Auth::user()->balance;
        $user_balance -=$request->requested_amount;
        User::where('id', Auth::id())->update(['balance' => $user_balance]);

        $withdrawRequest = new WithdrawRequest();
        $withdrawRequest->withdraw_method_id = $request->withdraw_method_id;
        $withdrawRequest->user_id = Auth::user()->id;
        $withdrawRequest->payment_details = $request->details;
        $withdrawRequest->payable_amount = $request->requested_amount;

        $withdrawRequest->save();

        $tr = new Transition;
        $tr->uid = Auth::user()->id;
        $tr->reason = "Withdrawal";
        $tr->transition = "-".$request->requested_amount;
        $tr->save();
        //redirect
        Session()->flash('success', 'withdraw request submitted!');
        return redirect()->route('user.withdraw');

    }

    // Campaigns
    public function campaigns(){
        $campaigns = CampaignApp::where('uid', Auth::id())->latest()->paginate(10);
        return view('user.pages.campaigns', compact('campaigns'));
    }

    // Mobile Verification
    public function mobileNotVerified(){
        if(Auth::user()->app_status!=0){
            return redirect()->back();
        }
        return view('user.pages.mobile-not-ver');
    }
    public function verifyMobiler(){
        if(Auth::user()->app_status!=0){
            return redirect()->back();
        }
        $textlocal = new Textlocal('rajdeepsinha156@gmail.com', 'anabeanaraJ@1');
        
        $numbers = array(Auth::user()->phone);
        $sender = urlencode('TXTLCL');
        $otp = rand(1000,9999);
        $message = 'The OTP to verify your mobile number at '.config('app.name').' is: '.$otp;
        
        try {
            $result = $textlocal->sendSms($numbers, $message, $sender);
            return view('user.pages.verify-mobile')->with([
                'otpv' => Hash::make($otp),
            ]);
        } catch (Exception $e) {
            die('Error: ' . $e->getMessage());
        }
    }
    public function verifyMobile(Request $request){
        $this->validate($request,[
            'otp' => 'required',
            'otpv' => 'required',
        ]);
        if(Hash::check($request->otp, $request->otpv)){
            $user = Auth::user();
            $user->app_status = 1;
            $user->save();
            $request->session()->flash('success', "OTP verified");
            return redirect()->route('user.dashboard');
        }
        else{
            $request->session()->flash('error', "OTP is not correct");
            return view('user.pages.verify-mobile')->with([
                'otpv' => $request->otpv,
            ]);
        }
    }
    public function email_verified($id){
        $user = User::find($id);
        $user->email_verified_at = new \DateTime();
        $user->save();
        return view('email-verified');
    }
}
