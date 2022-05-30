<?php

namespace App\Http\Controllers\Auth;

use App\Http\Controllers\Controller;
use App\Providers\RouteServiceProvider;
use App\User;
use Illuminate\Foundation\Auth\RegistersUsers;
use Illuminate\Support\Facades\Hash;
use Illuminate\Support\Facades\Auth;
use Illuminate\Support\Facades\Validator;

class RegisterController extends Controller
{
    /*
    |--------------------------------------------------------------------------
    | Register Controller
    |--------------------------------------------------------------------------
    |
    | This controller handles the registration of new users as well as their
    | validation and creation. By default this controller uses a trait to
    | provide this functionality without requiring any additional code.
    |
    */

    use RegistersUsers;

    /**
     * Where to redirect users after registration.
     *
     * @var string
     */
    protected $redirectTo = RouteServiceProvider::HOME;

    /**
     * Create a new controller instance.
     *
     * @return void
     */
    public function __construct()
    {
        $this->middleware('guest');
    }

    /**
     * Get a validator for an incoming registration request.
     *
     * @param  array  $data
     * @return \Illuminate\Contracts\Validation\Validator
     */
    protected function validator(array $data)
    {
        return Validator::make($data, [
            'name' => ['required', 'string', 'max:255'],
            'email' => ['required', 'string', 'email', 'max:255', 'unique:users'],
            'phone' => ['required'],
            'password' => ['required', 'string', 'min:8', 'confirmed'],
            'ref_by' => ['nullable','string'],
        ]);
    }

    /**
     * Create a new user instance after a valid registration.
     *
     * @param  array  $data
     * @return \App\User
     */
    protected function create(array $data)
    {
        if($data['ref_by']!=NULL){
            if(\App\User::where('ref_code',$data['ref_by'])->exists()){
                $user = \App\User::where('ref_code',$data['ref_by'])->first();
                $ref_by = $user->id;
            }
            else{
                Session()->flash('error', "Refral code does not exist");
                $ref_by=NULL;
            }
        }
        else{
            $ref_by = NULL;
        }
        while(true){
            $ref_code = $this->randstr(5);
            if(\App\User::where('ref_code',$ref_code)->exists()){

            }
            else{
                break;
            }
        }

        $user = User::create([
            'name' => $data['name'],
            'email' => $data['email'],
            'user_name' => $data['email'],
            'phone' => $data['phone'],
            'password' => Hash::make($data['password']),
            'ref_by' => $ref_by,
            'ref_code' => $ref_code,
        ]);
        Auth::login($user);
        return $user;
    }
    public function randstr ($len=10, $abc="aAbBcCdDeEfFgGhHiIjJkKlLmMnNoOpPqQrRsStTuUvVwWxXyYzZ0123456789") 
    {
        $letters = str_split($abc);
        $str = "";
        for ($i=0; $i<=$len; $i++) {
            $str .= $letters[rand(0, count($letters)-1)];
        };
        return $str;
    }
}
