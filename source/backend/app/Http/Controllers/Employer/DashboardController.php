<?php

namespace App\Http\Controllers\Employer;

use App\Http\Controllers\Controller;
use Illuminate\Http\Request;

use App\Employer;
use App\User;


use Illuminate\Support\Facades\Auth;
use Illuminate\Support\Facades\Hash;

class DashboardController extends Controller
{
    public function brand(){
        $emp = Employer::find(Auth::guard('employer')->id());
        return view('employer.pages.edit-brand')->with([
            'emp' => $emp,
        ]);
    }
    public function savecompany(Request $request){
        $this->validate($request,[
            'cname' => 'required',
            'description' => 'required',
            'website' => 'required',
        ]);
        $emp = Employer::find(Auth::guard('employer')->id());
        if ($request->hasFile('profile_image')) {

            try {

                $uploaddir = 'assets/employer/profile_images/';

                $file_name = 'Employer_'.$emp->name.'_'.$_FILES['profile_image']['name'];
                $uploadfile = $uploaddir . $file_name;

                if($emp->profile_photo!=NULL){
                    unlink($uploaddir.$emp->profile_photo);
                }
                $emp->profile_photo = $file_name;

                move_uploaded_file($_FILES['profile_image']['tmp_name'], $uploadfile);

            }catch(\Exception $exp) {
                Session()->flash('warning', 'image upload failed !');
                return redirect()->back();
            }
        }
        $emp->cname = $request->cname;
        $emp->description = $request->description;
        $emp->website = $request->website;
        $emp->save();
        Session()->flash('success','Company Details Saved');
        return redirect()->route('employer.dashboard');
    }

    public function dashboard(){
        $employer = Employer::find(Auth::guard('employer')->id());
        return view('employer.pages.dashboard')->with([
            'employer' => $employer
        ]);
    }
    public function profile(){
        $employer = Employer::find(Auth::guard('employer')->id());
        return view('employer.pages.profile')->with([
            'employer' => $employer
        ]);
    }
    public function update_profile(Request $request){
        if(!Auth::guard('employer')->check()){
            return redirect()->route('employer.loginr');
        }
        $this->validate($request,[
            'name' => 'required|max:50',
            'email' => 'required',
            'phone' => 'required',
            'category' => 'required',
            'website' => 'nullable',
            'cin' => 'required',
            'description' => 'required',
            'gstin' => 'required',
            'pan' => 'required',
            'country' => 'required',
            'city' => 'required',
            'state' => 'required',
            'zip_code' => 'required',
            'address' => 'required',
            'facebook' => 'nullable',
            'twitter' => 'nullable',
            'gplus' => 'nullable',
            'youtube' => 'nullable',
            'vimeo' => 'nullable',
            'linkedin' => 'nullable',
        ]);
        $em = Employer::find(Auth::guard('employer')->id());

        $em->name = $request->input('name');
        $em->email = $request->input('email');
        $em->phone = $request->input('phone');
        $em->category = $request->input('category');
        $em->cin = $request->input('cin');
        $em->website = $request->input('website');
        $em->description = $request->input('description');
        $em->pan = $request->input('pan');
        $em->gstin = $request->input('gstin');

        $em->city = $request->input('city');
        $em->country = $request->input('country');
        $em->state = $request->input('state');
        $em->zip_code = $request->input('zip_code');
        $em->address = $request->input('address');

        $em->facebook = $request->input('facebook');
        $em->twitter = $request->input('twitter');
        $em->gplus = $request->input('gplus');
        $em->youtube = $request->input('youtube');
        $em->vimeo = $request->input('vimeo');
        $em->linkedin = $request->input('linkedin');

        $em->save();

        Session()->flash('success','Profile Updated');
        return redirect()->back();
    }

    public function upload_profile_image(Request $request){
        $employer = Employer::find(Auth::guard('employer')->id());
        if ($request->hasFile('profile_image')) {

            try {

                $uploaddir = 'assets/employer/profile_images/';

                $file_name = 'Employer_'.$employer->name.'_'.$_FILES['profile_image']['name'];
                $uploadfile = $uploaddir . $file_name;

                if($employer->profile_photo!=NULL){
                    unlink($uploaddir.$employer->profile_photo);
                }
                $employer->profile_photo = $file_name;
                $employer->save();

                move_uploaded_file($_FILES['profile_image']['tmp_name'], $uploadfile);

                Session()->flash('success','Image upload successful!');

            }catch(\Exception $exp) {
                Session()->flash('warning', 'image upload failed !');
                return redirect()->back();
            }
        }
        return redirect()->back();
    }
    public function change_passr(){
        $employer = Employer::find(Auth::guard('employer')->id());
        return view('employer.pages.change-pass')->with([
            'employer' => $employer
        ]);
    }
    public function change_pass(Request $request){
        $employer = Employer::find(Auth::guard('employer')->id());
        $this->validate($request,[
            'opass' => "required|min:5",
            'password' => "required|min:5",
            'repass' => "required|min:5",
        ]);
        if($request->password!=$request->repass){
            Session()->flash('warning','New passwords do not match');
            return redirect()->back();
        }
        else{
            if(Hash::check($request->opass,$employer->password)){
                $employer->password = Hash::make($request->password);
                $employer->save();
                Session()->flash('success','Password is changed');
                return redirect()->back();
            }
            else{
                Session()->flash('warning','Old password is incorrect');
                return redirect()->back();
            }
        }
    }
}
