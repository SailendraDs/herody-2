<?php

namespace App\Http\Controllers;

use Illuminate\Http\Request;
use App\Country;
use App\State;
use App\City;

class WorldController extends Controller
{
    public function states(Request $request){
        $this->validate($request,[
            'country'=>'required'
        ]);
        $country = $request->input('country');
        $country = Country::where('name',$country)->first();
        $states = State::where('country_id',$country->id)->orderBy('name','asc')->get();
        
        return response()->json(array('states'=>$states),200);
    }
    public function cities(Request $request){
        $this->validate($request,[
            'state'=>'required'
        ]);
        $state = $request->input('state');
        $state = State::where('name',$state)->first();
        $cities = City::where('state_id',$state->id)->orderBy('name','asc')->get();
        
        return response()->json(array('cities'=>$cities),200);
    }
}
