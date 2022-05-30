@extends('layouts.app')
@section("title",config("app.name"))
@section('content')
<!-- Start Home -->
<section class="bg-home">
    <div class="bg-overlay"></div>
    <div class="home-center">
        <div class="home-desc-center">
            <div class="container">
                <div class="row justify-content-center">
                    <div class="col-lg-12">
                        <div class="title-heading text-center text-white">
                            <h6 class="small-title text-uppercase text-light mb-3">Find works, create trackable resumes and enrich your applications.</h6>
                            <h1 class="heading font-weight-bold mb-4">The Easiest Way to Get Your New Work</h1>
                        </div>
                    </div>
                </div>
                <div class="home-form-position">
                    <div class="row">
                        <div class="col-lg-12">
                            <div class="home-registration-form p-4 mb-3">
                                <form class="registration-form" method="POST" action="{{route("work.cat")}}">
                                    @csrf
                                    <div class="row">
                                        <div class="col-lg-9 col-md-9">
                                            <div class="registration-form-box">
                                                <i class="fa fa-list-alt"></i>
                                                <select id="select-category" name="cat" class="demo-default">
                                                    <option value="">Categories...</option>
                                                    @foreach ($cats as $cat)
                                                        <option value="{{$cat}}">{{$cat}}</option>
                                                    @endforeach
                                                </select>
                                            </div>
                                        </div>
                                        <div class="col-lg-3 col-md-6">
                                            <div class="registration-form-box">
                                                <input type="submit" id="submit" name="send" class="submitBnt btn btn-primary btn-block" value="Submit">
                                            </div>
                                        </div>
                                    </div>
                                </form>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </div>
</section>
<!-- end home -->

@if($works->count()>0)
<!-- all jobs start -->
<section class="section bg-light">
    <div class="container">
        <div class="row justify-content-center">
            <div class="col-12">
                <div class="section-title text-center mb-4 pb-2">
                    <h4 class="title title-line pb-5">Find Your Jobs</h4>
                    <p class="text-muted para-desc mx-auto mb-1">Post a job to tell us about your project. We'll quickly match you with the right freelancers.</p>
                </div>
            </div>
        </div>
        <div class="row">
            <div class="col-12">
                <div class="tab-content mt-2" id="pills-tabContent">
                    <div class="tab-pane fade show active" id="recent-job" role="tabpanel" aria-labelledby="recent-job-tab">
                        <div class="row">
                            <div class="col-lg-12">
                                @foreach($works as $work)
                                <div class="job-box bg-white overflow-hidden border rounded mt-4 position-relative overflow-hidden">
                                    <div class="lable text-center pt-2 pb-2">
                                        <ul class="list-unstyled best text-white mb-0 text-uppercase">
                                            <li class="list-inline-item"><i class="mdi mdi-star"></i></li>
                                        </ul>
                                    </div>
                                    <div class="p-4">
                                        <div class="row align-items-center">
                                            <div class="col-md-6">
                                                <div>
                                                    <h5 class="f-18"><a href="{{route("work.details",[$work->id,md5($work->name)])}}" class="text-dark">{{$work->name}}</a></h5>
                                                    <p class="text-muted mb-0">{{$work->employer->cname}}</p>
                                                </div>
                                            </div>
                                            <div class="col-md-2">
                                                <div>
                                                    <p class="text-muted mb-0 mo-mb-2"><span class="text-primary">INR </span>{{$work->price}}</p>
                                                </div>
                                            </div>
                                            <div class="col-md-2">
                                                <div>
                                                    <p class="text-muted mb-0">{{$work->pricing}}</p>
                                                </div>
                                            </div>
                                        </div>
                                    </div>
                                    <div class="p-3 bg-light">
                                        <div class="row">
                                            <div class="col-md-2">
                                                <div>
                                                    <a href="{{route("work.details",[$work->id,md5($work->name)])}}" class="text-primary">Apply Now <i class="mdi mdi-chevron-double-right"></i></a>
                                                </div>
                                            </div>
                                        </div>
                                    </div>
                                </div>
                                @endforeach
                            </div>
                        </div>
                    </div>
                </div>
            </div>
        </div>
        <!-- end row -->
    </div>
    <!-- end containar -->
</section>
<!-- all jobs end -->
@endif

<!-- How it Work start -->
<section class="section">
    <div class="container">
        <div class="row justify-content-center">
            <div class="col-12">
                <div class="section-title text-center mb-4 pb-2">
                    <h4 class="title title-line pb-5">How It Work</h4>
                    <p class="text-muted para-desc mx-auto mb-1">Post a job to tell us about your project. We'll quickly match you with the right freelancers.</p>
                </div>
            </div>
        </div>
        <div class="row">
            <div class="col-md-4 mt-4 pt-2">
                <div class="how-it-work-box bg-light p-4 text-center rounded shadow">
                    <div class="how-it-work-img position-relative rounded-pill mb-3">
                        <img src="{{asset("assets/main/images/how-it-work/img-1.png")}}" alt="" class="mx-auto d-block" height="50">
                    </div>
                    <div>
                        <h5>Register an account</h5>
                        <p class="text-muted">Donec pede justo fringilla vel aliquet nec vulputate eget arcu. In enim justo rhoncus ut a, justo.</p>
                        <a href="#" class="text-primary">Read more <i class="mdi mdi-chevron-right"></i></a>
                    </div>
                </div>
            </div>
            <div class="col-md-4 mt-4 pt-2">
                <div class="how-it-work-box bg-light p-4 text-center rounded shadow">
                    <div class="how-it-work-img position-relative rounded-pill mb-3">
                        <img src="{{asset("assets/main/images/how-it-work/img-2.png")}}" alt="" class="mx-auto d-block" height="50">
                    </div>
                    <div>
                        <h5>Search your job</h5>
                        <p class="text-muted">Aliquam lorem ante dapibus in, viverra feugiatquis a tellus. Phasellus viverra nulla ut Quisque rutrum.</p>
                        <a href="#" class="text-primary">Read more <i class="mdi mdi-chevron-right"></i></a>
                    </div>
                </div>
            </div>
            <div class="col-md-4 mt-4 pt-2">
                <div class="how-it-work-box bg-light p-4 text-center rounded shadow">
                    <div class="how-it-work-img position-relative rounded-pill mb-3">
                        <img src="{{asset("assets/main/images/how-it-work/img-3.png")}}" alt="" class="mx-auto d-block" height="50">
                    </div>
                    <div>
                        <h5>Apply for job</h5>
                        <p class="text-muted">Nullam dictum felis eu pede mollis pretiumetus Integer tincidunt. Cras dapibus. semper nisi.</p>
                        <a href="#" class="text-primary">Read more <i class="mdi mdi-chevron-right"></i></a>
                    </div>
                </div>
            </div>
        </div>
    </div>
</section>
<!-- How it Work end -->

<!-- counter start -->
<section class="section bg-counter position-relative" style="background: url('https://via.placeholder.com/200X700//88929f/5a6270C/O https://placeholder.com/') center center;">
    <div class="bg-overlay bg-overlay-gradient"></div>
    <div class="container">
        <div class="row" id="counter">
            <div class="col-md-3 col-6">
                <div class="home-counter pt-4 pb-4">
                    <div class="float-left counter-icon mr-3">
                        <i class="mdi mdi-bank h1 text-white"></i>
                    </div>
                    <div class="counter-content overflow-hidden">
                        <h1 class="counter-value text-white mb-1" data-count="120">10</h1>
                        <p class="counter-name text-white text-uppercase mb-0">Companies</p>
                    </div>
                </div>
            </div>

            <div class="col-md-3 col-6">
                <div class="home-counter pt-4 pb-4">
                    <div class="float-left counter-icon mr-3">
                        <i class="mdi mdi-file-document-box h1 text-white"></i>
                    </div>
                    <div class="counter-content overflow-hidden">
                        <h1 class="counter-value text-white mb-1" data-count="480">80</h1>
                        <p class="counter-name text-white text-uppercase mb-0">Applications</p>
                    </div>
                </div>
            </div>

            <div class="col-md-3 col-6">
                <div class="home-counter pt-4 pb-4">
                    <div class="float-left counter-icon mr-3">
                        <i class="mdi mdi-calendar-multiple-check h1 text-white"></i>
                    </div>
                    <div class="counter-content overflow-hidden">
                        <h1 class="counter-value text-white mb-1" data-count="120">10</h1>
                        <p class="counter-name text-white text-uppercase mb-0">Job Posted</p>
                    </div>
                </div>
            </div>
            <div class="col-md-3 col-6">
                <div class="home-counter pt-4 pb-4">
                    <div class="float-left counter-icon mr-3">
                        <i class="mdi mdi-account-multiple-plus h1 text-white"></i>
                    </div>
                    <div class="counter-content overflow-hidden">
                        <h1 class="counter-value text-white mb-1" data-count="200">10</h1>
                        <p class="counter-name text-white text-uppercase mb-0">Member</p>
                    </div>
                </div>
            </div>
        </div>

    </div>
</section>
<!-- counter end -->

<!-- testimonial start -->
<section class="section">
    <div class="container">
        <div class="row justify-content-center">
            <div class="col-12">
                <div class="section-title text-center mb-4 pb-2">
                    <h4 class="title title-line pb-5">Our Success Stories</h4>
                    <p class="text-muted para-desc mx-auto mb-1">Post a job to tell us about your project. We'll quickly match you with the right freelancers.</p>
                </div>
            </div>
        </div>
        <div class="row pt-4">
            <div class="col-lg-12">
                <div id="owl-testi" class="owl-carousel owl-theme">
                    <div class="item testi-box rounded p-4 mr-3 ml-2 mb-4 bg-light position-relative">
                        <p class="text-muted mb-5">Neque porro quisquam est, qui dolorem ipsum quia dolor sit amet consecteturqui adipisci velit, sed quia non numquam eius modi tempora incidunt ut labore et dolore magnam aliquam</p>
                        <div class="clearfix">
                            <div class="testi-img float-left mr-3">
                                <img src="https://via.placeholder.com/400X400//88929f/5a6270C/O https://placeholder.com/" height="64" alt="" class="rounded-circle shadow">
                            </div>
                            <h5 class="f-18 pt-1">Kevin Stewart</h5>
                            <p class="text-muted mb-0">Web Designer at xyz Company</p>
                            <div class="testi-icon">
                                <i class="mdi mdi-format-quote-open display-2"></i>
                            </div>
                        </div>
                    </div>

                    <div class="item testi-box rounded p-4 mr-3 ml-2 bg-light position-relative">
                        <p class="text-muted mb-5">Sed ut perspiciatis unde omnis iste natus error sit voluptatem accusantium, eaque ipsa quae ab illo inventore veritatis et quasi architecto beatae vitae dicta sunt explicabo</p>
                        <div class="clearfix">
                            <div class="testi-img float-left mr-3">
                                <img src="https://via.placeholder.com/400X400//88929f/5a6270C/O https://placeholder.com/" height="64" alt="" class="rounded-circle shadow">
                            </div>
                            <h5 class="f-18 pt-1">Charles Garrett</h5>
                            <p class="text-muted mb-0">Marketing manager at abc Company</p>
                            <div class="testi-icon">
                                <i class="mdi mdi-format-quote-open display-2"></i>
                            </div>
                        </div>
                    </div>

                    <div class="item testi-box rounded p-4 mr-3 ml-2 bg-light position-relative">
                        <p class="text-muted mb-5">Neque porro quisquam est, qui dolorem ipsum quia dolor sit amet consecteturqui adipisci velit, sed quia non numquam eius modi tempora incidunt ut labore et dolore magnam aliquam</p>
                        <div class="clearfix">
                            <div class="testi-img float-left mr-3">
                                <img src="https://via.placeholder.com/400X400//88929f/5a6270C/O https://placeholder.com/" height="64" alt="" class="rounded-circle shadow">
                            </div>
                            <h5 class="f-18 pt-1">Perry Martinez</h5>
                            <p class="text-muted mb-0">Marketing manager at abc Company</p>
                            <div class="testi-icon">
                                <i class="mdi mdi-format-quote-open display-2"></i>
                            </div>
                        </div>
                    </div>
                </div>

            </div>
        </div>
    </div>

    <div class="container mt-100 mt-60">
        <div class="row justify-content-center">
            <div class="col-12">
                <div class="section-title text-center mb-4 pb-2">
                    <h4 class="title title-line pb-5">Our Client's</h4>
                    <p class="text-muted para-desc mx-auto mb-1">Post a job to tell us about your project. We'll quickly match you with the right freelancers.</p>
                </div>
            </div>
        </div>

        <div class="row align-items-center">
            <div class="col-lg-2 col-md-4 col-6 mt-4 pt-2 text-center">
                <img src="images/clients/1.png" height="50" alt="">
            </div><!--end col-->
            <div class="col-lg-2 col-md-4 col-6 mt-4 pt-2 text-center">
                <img src="images/clients/2.png" height="50" alt="">
            </div><!--end col-->
            <div class="col-lg-2 col-md-4 col-6 mt-4 pt-2 text-center">
                <img src="images/clients/3.png" height="50" alt="">
            </div><!--end col-->
            <div class="col-lg-2 col-md-4 col-6 mt-4 pt-2 text-center">
                <img src="images/clients/4.png" height="50" alt="">
            </div><!--end col-->
            <div class="col-lg-2 col-md-4 col-6 mt-4 pt-2 text-center">
                <img src="images/clients/1.png" height="50" alt="">
            </div><!--end col-->
            <div class="col-lg-2 col-md-4 col-6 mt-4 pt-2 text-center">
                <img src="images/clients/2.png" height="50" alt="">
            </div><!--end col-->
        </div>
    </div>
</section>
<!-- testimonial end -->
@endsection