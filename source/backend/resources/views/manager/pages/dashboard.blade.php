@extends(' manager.master')

@section('title', 'Manager Dashboard')
@section('body')


    <h2 class="mb-4">Dashboard</h2>

    <div class="row mb-4">
        <div class="col-md-4">
            <div class="d-flex border">
                <div class="badge-danger text-light p-4">
                    <div class="d-flex align-items-center h-100">
                        <i class="fas fa-3x fa-fw fa-pause"></i>
                    </div>
                </div>
                <div class="flex-grow-1 bg-white p-4">
                    <a href="{{route('manager.work.pending')}}" style="text-decoration: none;"><p class="text-uppercase text-secondary mb-0">Pending Works</p></a>
                    <h3 class="font-weight-bold mb-0">{{count($pendingWorks)}}</h3>
                </div>
            </div>
        </div>
        <div class="col-md-4">
            <div class="d-flex border">
                <div class="bg-warning text-light p-4">
                    <div class="d-flex align-items-center h-100">
                        <i class="fa fa-3x fa-fw fa-spinner"></i>

                    </div>
                </div>
                <div class="flex-grow-1 bg-white p-4">
                    <a href="{{route('manager.work.all')}}" style="text-decoration: none;"><p class="text-uppercase text-secondary mb-0">In-Progress Works</p></a>
                    <h3 class="font-weight-bold mb-0">{{count($works)}}</h3>
                </div>
            </div>
        </div>
        <div class="col-md-4">
            <div class="d-flex border">
                <div class="bg-primary text-light p-4">
                    <div class="d-flex align-items-center h-100">
                        <i class="fa fa-3x fa-fw fa-users"></i>

                    </div>
                </div>
                <div class="flex-grow-1 bg-white p-4">
                    <a href="{{route('manager.employers')}}" style="text-decoration: none;"><p class="text-uppercase text-secondary mb-0">All Companies</p></a>
                    <h3 class="font-weight-bold mb-0">{{count($employers)}}</h3>
                </div>
            </div>
        </div>
    </div>

    <div class="row mb-4">

        <div class="col-md-4">
            <div class="d-flex border">
                <div class="customs_bd text-light p-4">
                    <div class="d-flex align-items-center h-100">
                        <i class="fa fa-3x fa-fw fa-users"></i>
                    </div>
                </div>
                <div class="flex-grow-1 bg-white p-4">
                    <a href="{{route('manager.member.all')}}" style="text-decoration: none;"><p class="text-uppercase text-secondary mb-0">All Workers</p></a>

                    <h3 class="font-weight-bold mb-0">{{count($allUsers)}}</h3>
                </div>
            </div>
        </div>
    </div>


@endsection