<!DOCTYPE html>
<html lang="en">
<head>
    <title>Admin Login</title>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <!-- fa pls -->
    <link href="https://daneden.github.io/animate.css/animate.min.css" rel="stylesheet">

    <!-- animate.css -->
    <link href="https://fonts.googleapis.com/css?family=Roboto:400,100,400italic,700italic,700" rel="stylesheet"/>

    {{--toastr--}}
    <script src="https://code.jquery.com/jquery-2.1.1.min.js"></script>
    <link href="{{asset('assets/toastr/toastr.min.css')}}" rel="stylesheet"/>
    <script src="{{asset('assets/toastr/toastr.min.js')}}"></script>


    <style>
        body {
            background: #3e2bc5 url({{asset('assets/admin/img/bg.png')}}) no-repeat center center fixed;
            -webkit-background-size: cover;
            -moz-background-size: cover;
            -o-background-size: cover;
            background-size: cover;
            font-family: "Roboto";
            -webkit-font-smoothing: antialiased;
            -moz-osx-font-smoothing: grayscale;
        }

        *, :after, :before {
            box-sizing: border-box
        }

        .clearfix:after, .clearfix:before {
            content: '';
            display: table
        }

        .clearfix:after {
            clear: both;
            display: block
        }

        a {
            color: inherit;
            text-decoration: none
        }

        .login-wrap {
            width: 100%;
            margin: auto;
            max-width: 525px;
            min-height: 500px;
            position: relative;
            box-shadow: 0 12px 15px 0 rgba(0, 0, 0, .24), 0 17px 50px 0 rgba(0, 0, 0, .19);
            margin-top: 8%;
        }

        .login-html {
            width: 100%;
            height: 100%;
            position: absolute;
            padding: 90px 70px 50px 70px;
            background: rgba(40, 57, 101, .9);
        }

        .login-html .sign-in-htm,
        .login-html .sign-up-htm {
            top: 0;
            left: 0;
            right: 0;
            bottom: 0;
            position: absolute;
            transform: rotateY(180deg);
            backface-visibility: hidden;
            transition: all .4s linear;
        }

        .login-html .sign-in,
        .login-html .sign-up,
        .login-form .group .check {
            display: none;
        }

        .login-html .tab,
        .login-form .group .label,
        .login-form .group .button {
            text-transform: uppercase;
        }

        .login-html .tab {
            font-size: 22px;
            margin-right: 15px;
            padding-bottom: 5px;
            margin: 0 15px 10px 0;
            display: inline-block;
            border-bottom: 2px solid transparent;
        }

        .login-html .sign-in:checked + .tab,
        .login-html .sign-up:checked + .tab {
            color: #fff;
            border-color: #1161ee;
        }

        .login-form {
            min-height: 345px;
            position: relative;
            perspective: 1000px;
            transform-style: preserve-3d;
        }

        .login-form .group {
            margin-bottom: 15px;
        }

        .login-form .group .label,
        .login-form .group .input,
        .login-form .group .button {
            width: 100%;
            color: #fff;
            display: block;
        }

        .login-form .group .input,
        .login-form .group .button {
            border: none;
            padding: 15px 20px;
            border-radius: 25px;
            background: rgba(255, 255, 255, .1);
        }

        .login-form .group input[data-type="password"] {
            text-security: circle;
            -webkit-text-security: circle;
        }

        .login-form .group .label {
            color: #aaa;
            font-size: 12px;
        }

        .login-form .group .button {
            background: #1161ee;
        }

        .login-form .group label .icon {
            width: 15px;
            height: 15px;
            border-radius: 2px;
            position: relative;
            display: inline-block;
            background: rgba(255, 255, 255, .1);
        }

        .login-form .group label .icon:before,
        .login-form .group label .icon:after {
            content: '';
            width: 10px;
            height: 2px;
            background: #fff;
            position: absolute;
            transition: all .2s ease-in-out 0s;
        }

        .login-form .group label .icon:before {
            left: 3px;
            width: 5px;
            bottom: 6px;
            transform: scale(0) rotate(0);
        }

        .login-form .group label .icon:after {
            top: 6px;
            right: 0;
            transform: scale(0) rotate(0);
        }

        .login-form .group .check:checked + label {
            color: #fff;
        }

        .login-form .group .check:checked + label .icon {
            background: #1161ee;
        }

        .login-form .group .check:checked + label .icon:before {
            transform: scale(1) rotate(45deg);
        }

        .login-form .group .check:checked + label .icon:after {
            transform: scale(1) rotate(-45deg);
        }

        .login-html .sign-in:checked + .tab + .sign-up + .tab + .login-form .sign-in-htm {
            transform: rotate(0);
        }

        .login-html .sign-up:checked + .tab + .login-form .sign-up-htm {
            transform: rotate(0);
        }

        .hr {
            height: 2px;
            margin: 60px 0 50px 0;
            background: rgba(255, 255, 255, .2);
        }

        .foot-lnk {
            text-align: center;
        }

        .help-block {
            color: red;
        }


    </style>
</head>
<body>

{{--toastr--}}
<script>
    @if(Session()->has('success'))

toastr.success("{{Session('success')}}")
    @endif

    @if(Session()->has('warning'))

toastr.warning("{{Session('warning')}}")
    @endif
</script>


<div class="login-wrap">
    <div class="login-html" style="text-align: center;">

        <div class="logo" style="margin-bottom: 40px;">
            <img src="{{asset('assets/main/images/logo.png')}}" alt="logo"
                 style="max-width: 100%; max-height: 60px;">
        </div>
        <input id="tab-1" type="radio" name="tab" class="sign-in" checked=""><label for="tab-1" class="tab">Admin
            Login</label>
        <input id="tab-2" type="radio" name="tab" class="sign-up"><label for="tab-2" class="tab"></label>

        <div class="login-form" style="margin-top: 40px;">
            <div class="sign-in-htm">

                <form method="post" action="{{route('admin')}}">
                    @csrf
                    <div class="group">
                        <input placeholder="Username" name="userName" class="input" type="text"
                               required="">
                    </div>
                    <div class="group">
                        <input placeholder="Password" name="password" class="input" type="password"
                               required="">
                    </div>

                    <div class="group">
                        <input type="submit" class="button" value="Log In">
                    </div>
                </form>
            </div>
        </div>
    </div>
</div>


</body>
</html>
