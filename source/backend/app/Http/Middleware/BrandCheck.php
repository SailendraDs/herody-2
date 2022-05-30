<?php

namespace App\Http\Middleware;

use Closure;
use Illuminate\Support\Facades\Auth;
use App\Employer;

class BrandCheck
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
        if(Auth::guard('employer')->check()){
            $emp = Employer::find(Auth::guard('employer')->id());
            if($emp->cname==NULL){
                return redirect()->route('employer.brand');
            }
        }
        return $next($request);
    }
}
