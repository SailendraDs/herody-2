@extends('admin.master')

@section('title', 'Admin | All Support Messages')

@section('body')

    <div class="container-fluid">
        <h2 class="mb-4">Support Messages List</h2>

        <div class="card mb-4">
            <div class="card-header bg-white font-weight-bold">
                Support Messages
            </div>
            <div class="card-body">
                @if(count($supports)==0)
                    <h2 class="text-center">@lang('No Data Available')</h2>
                @else
                    <table class="table table-striped table-bordered">
                        <thead>
                        <tr>
                            <th scope="col">ID</th>
                            <th scope="col">Sender</th>
                            <th scope="col">Sender Type</th>
                            <th scope="col">Team Member</th>
                            <th scope="col">Last Message</th>
                            <th scope="col">Status</th>
                            <th scope="col">Created</th>
                            <th scope="col"></th>
                        </tr>
                        </thead>
                        <tbody>

                        @foreach($supports as $support)
                        <?php   
                            $type = $support->sender_type;
                            $uid = $support->sender_id;
                            if($type === "Support"){
                                $name = "Support";
                                $image = "assets/main/images/logo-dark.png";
                            }
                            else if($type === "User"){
                                $name = \App\User::find($uid)->name;
                                $image = \App\User::find($uid)->profile_photo===NULL? 'assets/user/images/frontEnd/demo.png' :"assets/user/images/user_profile/".\App\User::find($id)->profile_photo;
                            }
                            else if($type === "Company"){
                                $name = \App\Employer::find($uid)->name;
                                $image = "assets/employer/profile_images/".(\App\Employer::find($uid)->profile_photo ?? "default.png");
                            }
                        ?>
                            <tr>
                                <th scope="row">{{$loop->iteration}}</th>
                                <th scope="row">{{$name}}</th>
                                <th scope="row">{{$type}}</th>
                                <th scope="row">{{\App\Manager::find($support->team_id)->name}}</th>
                                <th scope="row">{{\Carbon\Carbon::parse(\App\Chat::where("support_id",$support->id)->latest()->first()->created_at)->diffForHumans()}}</th>
                                <th scope="row">{{$support->status}}</th>
                                <th scope="row">{{\Carbon\Carbon::parse($support->created_at)->diffForHumans()}}</th>
                                <th scope="row">
                                    <form action="{{route("admin.supports.delete")}}">
                                        <input type="hidden" name="id" value="{{$support->id}}">
                                        <button class="btn btn-danger"><i class="fa fa-trash"></i></button>
                                    </form>
                                </th>
                            </tr>
                        @endforeach
                        </tbody>
                    </table>
                @endif
                {{$supports->links()}}
            </div>
        </div>
    </div>
@endsection