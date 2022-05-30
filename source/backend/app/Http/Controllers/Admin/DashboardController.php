<?php

namespace App\Http\Controllers\Admin;
use App\Admin;
use App\Work;
use App\User;
use App\Employer;
use App\Withdraw;
use Carbon\Carbon;

use App\Http\Controllers\Controller;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\Auth;
use Illuminate\Support\Facades\Hash;
use App\Mail\GlobalMail;
use Illuminate\Support\Facades\Mail;
use App\Transition;
class DashboardController extends Controller
{
    public function dashboard()
    {
        $works = Work::where("approved",1)->get();
        $pendingWorks = Work::where("approved",0)->get();
        $employers = Employer::get();
        $withdrawRequest = Withdraw::where('status',0)->get();
        $withdraws = Withdraw::where('status',1)->get();

        $allUsers = User::all();
        $acUsers = User::where('account_status',1)->get();
        $InAcUsers = User::where('account_status',0)->get();

        return view('admin.pages.dashboard', compact('InAcUsers','acUsers','allUsers','works','employers','pendingWorks', 'withdraws','withdrawRequest'));

    }
}
