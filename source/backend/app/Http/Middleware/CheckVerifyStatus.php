<?php

namespace App\Http\Middleware;

use App\GeneralSetting;
use Closure;
use Illuminate\Support\Facades\Auth;

class CheckVerifyStatus
{
    /**
     * Handle an incoming request.
     *
     * @param  \Illuminate\Http\Request  $request
     * @param  \Closure  $next
     * @return mixed
     */
    public function handle($request, Closure $next)
    {
        if (Auth::user()->verify_status == 0 OR Auth::user()->sms_verify_status == 0) {
            return redirect()->route('authentication');
        }
        return $next($request);

    }
}
