package org.yellcorp.airlib.file
{
import org.yellcorp.lib.events.EventTask;

import flash.events.Event;
import flash.events.EventDispatcher;
import flash.events.FileListEvent;
import flash.events.IOErrorEvent;
import flash.filesystem.File;


[Event(name="directoryListing", type="flash.events.FileListEvent")]
[Event(name="ioError", type="flash.events.IOErrorEvent")]
[Event(name="complete", type="flash.events.Event")]
[Event(name="cancel", type="flash.events.Event")]
public class Walker extends EventDispatcher
{
    private var pendingFolders:Array;
    private var fileFilter:Function;
    private var folderFilter:Function;
    private var folderDescend:Function;

    private var cancelled:Boolean;

    public function Walker(initialFolders:Array = null, fileFilter:Function = null, folderFilter:Function = null, folderDescend:Function = null)
    {
        super();

        this.fileFilter = fileFilter || WalkFilter.all;
        this.folderFilter = folderFilter || WalkFilter.all;
        this.folderDescend = folderDescend || WalkFilter.all;

        pendingFolders = initialFolders ? initialFolders.map(cloneFile) : [ ];
    }

    public function addFolder(folder:File):void
    {
        pendingFolders.push(new File(folder.url));
    }

    public function start():void
    {
        enumerateNext();
    }

    public function cancel():void
    {
        cancelled = true;
    }

    private function enumerateNext():void
    {
        var folder:File = pendingFolders.shift();
        if (cancelled)
        {
            dispatchEvent(new Event(Event.CANCEL));
        }
        else if (folder)
        {
            new EventTask(folder).
                handleOnce(FileListEvent.DIRECTORY_LISTING, onFileList).
                handleOnce(IOErrorEvent.IO_ERROR, onError).
                listen();
            folder.getDirectoryListingAsync();
        }
        else
        {
            dispatchEvent(new Event(Event.COMPLETE));
        }
    }

    private function onFileList(event:FileListEvent):void
    {
        var newResult:Array = [ ];

        for each (var fsItem:File in event.files)
        {
            if (fsItem.isDirectory)
            {
                if (folderFilter(fsItem))
                {
                    newResult.push(fsItem);
                }
                if (folderDescend(fsItem))
                {
                    pendingFolders.push(fsItem);
                }
            }
            else
            {
                if (fileFilter(fsItem))
                {
                    newResult.push(fsItem);
                }
            }
        }

        if (newResult.length > 0)
        {
            dispatchEvent(
                new FileListEvent(FileListEvent.DIRECTORY_LISTING,
                                  false, false,
                                  newResult));
        }
        enumerateNext();
    }

    private function onError(event:IOErrorEvent):void
    {
        dispatchEvent(event);
        enumerateNext();
    }

    private static function cloneFile(file:File, ...ignored):File
    {
        return new File(file.url);
    }
}
}
