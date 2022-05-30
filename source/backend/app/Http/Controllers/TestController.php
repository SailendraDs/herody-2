<?php

namespace App\Http\Controllers;

use Illuminate\Http\Request;
use App\User;
use App\Mail\certificate_mail;
use Illuminate\Support\Facades\Mail;
class TestController extends Controller
{
    public function test(){
        // $ch = curl_init();
        // curl_setopt($ch, CURLOPT_URL,"http://localhost/herody/api/user/get-session");
        // curl_setopt($ch, CURLOPT_POST, 1);
        // curl_setopt($ch, CURLOPT_POSTFIELDS,['id'=>77]);
        // curl_setopt($ch, CURLOPT_RETURNTRANSFER, true);
        // $res = curl_exec($ch);
        // curl_close ($ch);
        // $res = json_decode($res);
        // $id =  $res->response->id;
        // $ch = curl_init();
        // curl_setopt($ch, CURLOPT_URL,"http://localhost/herody/api/campaign/proof");
        // curl_setopt($ch, CURLOPT_POST, 1);
        // curl_setopt($ch, CURLOPT_POSTFIELDS,['id'=>$id,'cid'=>1,'uid'=>77]);
        // curl_setopt($ch, CURLOPT_RETURNTRANSFER, true);
        // $res = curl_exec($ch);
        // curl_close ($ch);
        // echo $res;
        // echo "<script>location.href='".env('APP_PLAYSTORE')."';</script>";4
        $data = array('user'=>"Lokendra Soni",'job'=>"This is a Job",'jid'=>1,'uid'=>71);
        Mail::to("lokendrasoni10@gmail.com")->send(new certificate_mail($data));
    }
}
