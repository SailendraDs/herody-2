<?php

namespace App\Http\Controllers;

use Illuminate\Http\Request;
use App\User;
use Illuminate\Support\Facades\Hash;
use Illuminate\Support\Facades\Auth;

class TrueCallerController extends Controller
{
    public function login(Request $request){
        $this->validate($request,[
            'accessToken' => 'required',
        ]);
        $ch = curl_init();
        curl_setopt($ch, CURLOPT_URL,$request->endpoint);
        curl_setopt($ch, CURLOPT_HTTPHEADER,array(
            'Authorization: Bearer '.$request->accessToken,
            'Cache-Control: no-cache'
        ));
        curl_setopt($ch, CURLOPT_RETURNTRANSFER, true);
        $res = curl_exec($ch);
        curl_close ($ch);
        $res = json_decode($res, true);
        $name = $res['name']['first']." ".$res['name']['last'];
        $email = $res['onlineIdentities']['email'];
        $phone = $res['phoneNumbers'][0];
        $pass = $res['userId'];

        $user = User::where('email',$email)->first();
        if($user==NULL){
            $user = new User;
            $user->email = $email;
            $user->user_name = $email;
            $user->name = $name;
            $user->phone = $phone;
            $user->password = Hash::make($pass);
            $user->save();
            Auth::login($user);
        }
        else{
            Auth::login($user);
        }
    }
}
