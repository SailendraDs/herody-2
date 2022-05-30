@extends('manager.master')

@section('title', 'Manager | Pending Works')

@section('body')

    <div class="container-fluid">
        <h2 class="mb-4">Pending List</h2>

        <div class="card mb-4">
            <div class="card-header bg-white font-weight-bold">
                Pending Works
            </div>
            <div class="card-body">
                @if(count($works)==0)
                    <h2 class="text-center">@lang('No Data Available')</h2>
                @else
                    <table class="table  table-striped table-bordered">
                        <thead>
                        <tr>
                            <th scope="col">ID</th>
                            <th scope="col">Name</th>
                            <th scope="col">Category</th>
                            <th scope="col">Apply Before</th>
                            <th scope="col">Price</th>
                            <th scope="col">Number of candidates Required</th>
                            <th scope="col">Duration</th>
                            <th scope="col">Action</th>
                        </tr>
                        </thead>
                        <tbody>

                        @foreach($works as $work)
                            <tr>
                                <th scope="row">{{$loop->iteration}}</th>
                                <td>{{$work->name}}</td>
                                <td>{{$work->category}}</td>
                                <td>{{$work->last_apply}}</td>
                                <td>{{$work->price}}</td>
                                <td>{{$work->candidates}}</td>
                                <td>{{$work->duration}}</td>
                                <td>

                                    <a href="" class="btn btn-danger btn-sm btn-square" data-id="{{$work->id}}"
                                       data-toggle="modal" data-target="#OrderReject">Reject</a>

                                    <a href="" class="btn btn-info btn-sm btn-square" data-id="{{$work->id}}"
                                       data-toggle="modal"
                                       data-target="#OrderApprove">Approve</a>
                                </td>

                            </tr>
                        @endforeach

                        </tbody>
                    </table>
                @endif
                {{$works->links()}}
            </div>
        </div>
    </div>


    {{--<!-- order Approve Alert Modal -->--}}
    <div class="modal modal-danger fade" id="OrderApprove" tabindex="-1" role="dialog" aria-labelledby="myModalLabel">
        <div class="modal-dialog" role="document">
            <div class="modal-content">
                <div class="modal-header">
                    <h4 class="modal-title" id="myModalLabel"><i class="fa fa-trash"></i> Approve !</h4>
                </div>
                <form action="{{route('manager.work.approve')}}" method="post">
                    @csrf
                    <div class="modal-body">
                        <input class="form-control form-control-lg mb-3" type="hidden" name="id" id="id">
                        <strong>Are you sure you want to Approve ?</strong>
                    </div>
                    <div class="modal-footer">
                        <button type="button" class="btn btn-danger" data-dismiss="modal">Cancel</button>
                        <button type="submit" class="btn btn-success">Yes</button>
                    </div>
                </form>
            </div>
        </div>
    </div>

    {{--<!-- order reject Alert Modal -->--}}
    <div class="modal modal-danger fade" id="OrderReject" tabindex="-1" role="dialog" aria-labelledby="myModalLabel">
        <div class="modal-dialog" role="document">
            <div class="modal-content">
                <div class="modal-header">
                    <h4 class="modal-title" id="myModalLabel"><i class="fa fa-trash"></i> Reject !</h4>
                </div>
                <form action="{{route('manager.work.delete')}}" method="post">
                    @csrf
                    <div class="modal-body">
                        <input class="form-control form-control-lg mb-3" type="hidden" name="id" id="id">
                        <strong>Are you sure you want to Delete ?</strong>
                    </div>
                    <div class="modal-footer">
                        <button type="button" class="btn btn-danger" data-dismiss="modal">Cancel</button>
                        <button type="submit" class="btn btn-success">Yes</button>
                    </div>
                </form>
            </div>
        </div>
    </div>

    {{--dropdown active--}}
    <script>
        $('#work li:nth-child(2)').addClass('active');
        $('#work').addClass('show');
    </script>
@endsection


@section('scripts')

    {{--Approve script--}}
    <script>
        $('#OrderReject').on('show.bs.modal', function (event) {

            var button = $(event.relatedTarget);
            var id = button.data('id');
            var modal = $(this);
            modal.find('.modal-body #id').val(id);
        })
    </script>

    {{--Reject script--}}
    <script>
        $('#OrderApprove').on('show.bs.modal', function (event) {

            var button = $(event.relatedTarget);
            var id = button.data('id');
            var modal = $(this);
            modal.find('.modal-body #id').val(id);
        })
    </script>

@endsection
