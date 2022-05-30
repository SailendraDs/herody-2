    <!-- Navigation Bar-->
    <header id="topnav" class="defaultscroll scroll-active">
      <!-- Menu Start -->
      <div class="container">
          <!-- Logo container-->
          <div>
              <a href="{{route("index")}}" class="logo">
                  <img src="{{asset("assets/main/images/logo-dark.png")}}" alt="" class="logo-dark" height="18" />
              </a>
          </div> 
          @if(!Auth::check() and !Auth::guard('employer')->check() and !Auth::guard('manager')->check())                
          <div class="buy-button">
              <a href="{{route("employer.for-businesses")}}" class="btn btn-primary"><i class="mdi mdi-cloud-upload"></i> For Companies</a>
          </div><!--end login button-->
          @endif
          <!-- End Logo container-->
          <div class="menu-extras">
              <div>
                  <!-- Mobile menu toggle-->
                  <a class="navbar-toggle">
                      <div class="lines">
                          <span></span>
                          <span></span>
                          <span></span>
                      </div>
                  </a>
                  <!-- End mobile menu toggle-->
              </div>
          </div>
  
          <div id="navigation">
              <!-- Navigation Menu-->   
              <ul class="navigation-menu">
                  <li @if(Request::route()->getName()==="index") class="active" @endif>
                    <a href="{{route("index")}}">Home</a>
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
          </div><!--end navigation-->
      </div><!--end container-->
      <!--end end-->
  </header><!--end header-->
  <!-- Navbar End -->