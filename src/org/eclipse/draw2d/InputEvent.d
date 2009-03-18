/*******************************************************************************
 * Copyright (c) 2000, 2005 IBM Corporation and others.
 * All rights reserved. This program and the accompanying materials
 * are made available under the terms of the Eclipse Public License v1.0
 * which accompanies this distribution, and is available at
 * http://www.eclipse.org/legal/epl-v10.html
 *
 * Contributors:
 *     IBM Corporation - initial API and implementation
 * Port to the D programming language:
 *     Frank Benoit <benoit@tionex.de>
 *******************************************************************************/
module org.eclipse.draw2d.InputEvent;

import java.lang.all;
import java.util.EventObject;
import java.util.EventObject;

import org.eclipse.swt.SWT;
import org.eclipse.draw2d.EventDispatcher;
import org.eclipse.draw2d.IFigure;

/**
 * The base class for Draw2d events.
 */
public abstract class InputEvent
    : /+java.util.+/EventObject
{

private int state;

private bool consumed = false;

/** @see SWT#ALT */
public static const int ALT = SWT.ALT;
/** @see SWT#CONTROL */
public static const int CONTROL = SWT.CONTROL;
/** @see SWT#SHIFT */
public static const int SHIFT = SWT.SHIFT;
/** @see SWT#BUTTON1 */
public static const int BUTTON1 = SWT.BUTTON1;
/** @see SWT#BUTTON2 */
public static const int BUTTON2 = SWT.BUTTON2;
/** @see SWT#BUTTON3 */
public static const int BUTTON3 = SWT.BUTTON3;
/** @see SWT#BUTTON4 */
public static const int BUTTON4 = SWT.BUTTON4;
/** @see SWT#BUTTON5 */
public static const int BUTTON5 = SWT.BUTTON5;
/** A bitwise OR'ing of {@link #BUTTON1}, {@link #BUTTON2}, {@link #BUTTON3},
 * {@link #BUTTON4} and {@link #BUTTON5} */
public static const int ANY_BUTTON = SWT.BUTTON_MASK;

/**
 * Constructs a new InputEvent.
 * @param dispatcher the event dispatcher
 * @param source the source of the event
 * @param state the state
 */
public this(EventDispatcher dispatcher, IFigure source, int state) {
    super(cast(Object)source);
    this.state = state;
}

/**
 * Marks this event as consumed so that it doesn't get passed on to other listeners.
 */
public void consume() {
    consumed = true;
}

/**
 * Returns the event statemask, which is a bitwise OR'ing of any of the following:
 * {@link #ALT}, {@link #CONTROL}, {@link #SHIFT}, {@link #BUTTON1}, {@link #BUTTON2},
 * {@link #BUTTON3}, {@link #BUTTON4} and {@link #BUTTON5}.
 * @return the state
 */
public int getState() {
    return state;
}

/**
 * @return whether this event has been consumed.
 */
public bool isConsumed() {
    return consumed;
}

}
