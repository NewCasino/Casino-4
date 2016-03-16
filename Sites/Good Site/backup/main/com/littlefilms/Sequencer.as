package com.littlefilms
{
    import flash.display.*;
    import flash.net.*;

    public class Sequencer extends Sprite
    {
        private var _mainMC:Main;
        private var _currentStep:uint;
        private var _currentSequence:String = null;
        private var _paneName:String;
        private var _paneType:String;
        private var _clickedNavItem:NavItem;

        public function Sequencer()
        {
            return;
        }// end function

        public function registerMain(param1:Main) : void
        {
            _mainMC = param1;
            return;
        }// end function

        public function changeSection(param1:String, param2:String) : void
        {
            _paneName = param1;
            _paneType = param2;
            trace("_paneName = " + _paneName);
            trace("_paneType = " + _paneType);
            if (_mainMC.paneManager.activePrimaryPane == null)
            {
                if (param1 == "ourBlog")
                {
                    launchBlog();
                }
                else
                {
                    _currentSequence = "activateNewSection";
                }
                _currentStep = 0;
            }
            else if (_mainMC.paneManager.activePrimaryPane != null)
            {
                trace("_mainMC.paneManager.activePrimaryPane = " + _mainMC.paneManager.activePrimaryPane);
                trace("_mainMC.paneManager.activePrimaryPane = " + _mainMC.paneManager.activePrimaryPane.name);
                if (param1 == "none")
                {
                    _currentSequence = "removeSection";
                }
                else if (param1 == "primary")
                {
                    _currentSequence = "deActivateDetailPane";
                }
                else if (param1 == "ourBlog")
                {
                    _currentSequence = "launchBlog";
                }
                else if (param2 == "member" || param2 == "project")
                {
                    _currentSequence = "activateDetailPane";
                }
                else
                {
                    _currentSequence = "swapSections";
                }
                _currentStep = 0;
            }
            nextStep();
            return;
        }// end function

        public function changeSubSection(param1:NavItem) : void
        {
            trace("Sequencer::changeSubSection()");
            _clickedNavItem = param1;
            _currentSequence = "swapSubSection";
            _currentStep = 0;
            nextStep();
            return;
        }// end function

        public function nextStep()
        {
            if (_currentSequence != null)
            {
                var _loc_2:* = _currentStep + 1;
                _currentStep = _loc_2;
                trace("");
                trace("_currentSequence ###\t= " + _currentSequence + " ### ");
                trace("_currentStep\t\t\t\t\t= " + _currentStep);
                switch(_currentSequence)
                {
                    case "activateNewSection":
                    {
                        switch(_currentStep)
                        {
                            case 1:
                            {
                                trace("add section background");
                                _mainMC.bgManager.addSectionBG(_paneName);
                                break;
                            }
                            case 2:
                            {
                                trace("add a content pane");
                                _mainMC.paneManager.addPane(_paneName, _paneType);
                                break;
                            }
                            case 3:
                            {
                                trace("set up the pane");
                                _mainMC.paneManager.activePrimaryPane.setUpPane();
                                break;
                            }
                            case 4:
                            {
                                trace("activate the pane");
                                _mainMC.paneManager.activatePane(_paneType);
                                break;
                            }
                            default:
                            {
                                trace(_currentSequence + " is finished");
                                _currentSequence = null;
                                _currentStep = 0;
                                trace("");
                                break;
                                break;
                            }
                        }
                        break;
                    }
                    case "swapSections":
                    {
                        switch(_currentStep)
                        {
                            case 1:
                            {
                                trace("remove current pane or panes)");
                                _mainMC.paneManager.clearActivePanes();
                                break;
                            }
                            case 2:
                            {
                                trace("add section background");
                                _mainMC.bgManager.addSectionBG(_paneName);
                                break;
                            }
                            case 3:
                            {
                                trace("add a content pane");
                                _mainMC.paneManager.addPane(_paneName, _paneType);
                                break;
                            }
                            case 4:
                            {
                                trace("set up the pane");
                                _mainMC.paneManager.activePrimaryPane.setUpPane();
                                break;
                            }
                            case 5:
                            {
                                trace("activate the pane");
                                _mainMC.paneManager.activatePane(_paneType);
                                break;
                            }
                            default:
                            {
                                trace(_currentSequence + " is finished");
                                _currentSequence = null;
                                _currentStep = 0;
                                trace("");
                                break;
                                break;
                            }
                        }
                        break;
                    }
                    case "removeSection":
                    {
                        switch(_currentStep)
                        {
                            case 1:
                            {
                                trace("remove current pane or panes)");
                                _mainMC.paneManager.clearActivePanes();
                                break;
                            }
                            case 2:
                            {
                                trace("remove current sectionBackground");
                                _mainMC.bgManager.removeSectionBG();
                                break;
                            }
                            default:
                            {
                                trace(_currentSequence + " is finished");
                                _currentSequence = null;
                                _currentStep = 0;
                                trace("");
                                break;
                                break;
                            }
                        }
                        break;
                    }
                    case "activateDetailPane":
                    {
                        switch(_currentStep)
                        {
                            case 1:
                            {
                                trace("remove current pane or panes)");
                                _mainMC.paneManager.minimizePrimaryPane();
                                break;
                            }
                            case 2:
                            {
                                trace("add section background");
                                _mainMC.bgManager.addSectionBG(_paneName);
                                break;
                            }
                            case 3:
                            {
                                trace("add a content pane");
                                _mainMC.paneManager.addPane(_paneName, _paneType);
                                break;
                            }
                            case 4:
                            {
                                trace("activate the pane");
                                _mainMC.paneManager.activatePane(_paneType);
                                break;
                            }
                            default:
                            {
                                trace(_currentSequence + " is finished");
                                _currentSequence = null;
                                _currentStep = 0;
                                trace("");
                                break;
                                break;
                            }
                        }
                        break;
                    }
                    case "deActivateDetailPane":
                    {
                        switch(_currentStep)
                        {
                            case 1:
                            {
                                trace("remove current pane or panes)");
                                _mainMC.paneManager.clearSecondaryPane();
                                break;
                            }
                            case 2:
                            {
                                trace("add section background");
                                _mainMC.bgManager.addSectionBG(_mainMC.paneManager.activePrimaryPane.lastSubSection);
                                break;
                            }
                            case 3:
                            {
                                trace("add a content pane");
                                _mainMC.paneManager.maximizePrimaryPane();
                                break;
                            }
                            default:
                            {
                                trace(_currentSequence + " is finished");
                                _currentSequence = null;
                                _currentStep = 0;
                                trace("");
                                break;
                                break;
                            }
                        }
                        break;
                    }
                    case "swapSubSection":
                    {
                        switch(_currentStep)
                        {
                            case 1:
                            {
                                trace("remove current pane content)");
                                _mainMC.paneManager.activePrimaryPane.removeCurrentContent(_clickedNavItem);
                                break;
                            }
                            case 2:
                            {
                                trace("add section background");
                                _mainMC.bgManager.addSectionBG(_clickedNavItem.name);
                                break;
                            }
                            case 3:
                            {
                                trace("reveal new pane content)");
                                _mainMC.paneManager.activePrimaryPane.revealNewContent(_clickedNavItem.name);
                                break;
                            }
                            default:
                            {
                                trace(_currentSequence + " is finished");
                                _currentSequence = null;
                                _currentStep = 0;
                                trace("");
                                break;
                                break;
                            }
                        }
                        break;
                    }
                    case "launchBlog":
                    {
                        switch(_currentStep)
                        {
                            case 1:
                            {
                                trace("remove current pane or panes)");
                                _mainMC.paneManager.clearActivePanes();
                                break;
                            }
                            case 2:
                            {
                                trace("remove current sectionBackground");
                                _mainMC.bgManager.removeSectionBG();
                                break;
                            }
                            case 3:
                            {
                                launchBlog();
                                break;
                            }
                            default:
                            {
                                trace(_currentSequence + " is finished");
                                _currentSequence = null;
                                _currentStep = 0;
                                trace("");
                                break;
                                break;
                            }
                        }
                        break;
                    }
                    default:
                    {
                        break;
                    }
                }
            }
            return;
        }// end function

        private function launchBlog() : void
        {
            _mainMC.footer.swapNav(null);
            var _loc_3:int = 0;
            var _loc_4:* = _mainMC.contentManager.contentXML.section;
            var _loc_2:* = new XMLList("");
            for each (_loc_5 in _loc_4)
            {
                
                var _loc_6:* = _loc_4[_loc_3];
                with (_loc_4[_loc_3])
                {
                    if (@id == "ourBlog")
                    {
                        _loc_2[_loc_3] = _loc_5;
                    }
                }
            }
            navigateToURL(new URLRequest(_loc_2.@blogURL.toString()), "_blank");
            return;
        }// end function

    }
}
