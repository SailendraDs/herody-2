
            <div class="header-section">
                <!--logo and logo icon start-->
                <div class="logo">
                    <a href="{{route("index")}}">
                        <!--<i class="fa fa-maxcdn"></i>-->
                        <span class="brand-name">{{config("app.name")}}</span>
                    </a>
                </div>

                <!--toggle button start-->
                <a class="toggle-btn"><i class="ti ti-menu"></i></a>
                <!--toggle button end-->

                <div class="notification-wrap">
                    <!--right notification start-->
                    <div class="right-notification">
                        <!-- Navigation Menu-->   
                        <ul class="notification-menu">
                            <li @if(Request::route()->getName()==="index") class="active" @endif>
                              <a href="{{route("index")}}" class="notification">Home</a>
                            </li>
                            <li @if(Request::route()->getName()==="works") class="active" @endif>
                              <a href="{{route("works")}}">Works</a>
                            </li>
                            <li @if(Request::route()->getName()==="join-team") class="active" @endif>
                              <a href="{{route("join-team")}}">Join Team</a>
                            </li>
                            <li @if(Request::route()->getName()==="custom-project") class="active" @endif>
                              <a href="{{route("custom-project")}}">Need a custom project?</a>
                            </li>
                            @if(!Auth::check() and !Auth::guard('employer')->check() and !Auth::guard('manager')->check())
                            <li>
                              <a href="{{route('register')}}">Register</a>
                            </li>
                            @endif
                            @if(Auth::check())
                            <li>
                              <a href="{{route('user.dashboard')}}">Worker Dashboard</a>
                            </li>
                            @endif
                            @if(Auth::guard('employer')->check())
                            <li>
                              <a href="{{route('employer.dashboard')}}">Company Dashboard</a>
                            </li>
                            @endif
                            @if(Auth::guard('manager')->check())
                            <li>
                              <a href="{{route('manager.dashboard')}}">Manager Dashboard</a>
                            </li>
                            @endif
                        </ul><!--end navigation menu-->
                    </div><!--right notification end-->
                </div>
            </div>