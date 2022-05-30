<table>
    <thead>
    <tr>
        <th>Work title</th>
        <th>Work Company</th>
        <th>Work Approval Status</th>
        <th>Created At</th>
    </tr>
    </thead>
    <tbody>
    @foreach($works as $work)
        <tr>
            <td>{{ $work->name }}</td>
            <td>{{ $work->employer->cname }}</td>
            <td>{{ $work->approved===1?"Approved":"Pending" }}</td>
            <td>{{ $work->created_at }}</td>
        </tr>
    @endforeach
    </tbody>
</table>