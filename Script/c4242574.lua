--Lunar Phase Beast: Moon Burst Clearing
function c4242574.initial_effect(c)
aux.EnablePendulumAttribute(c,true)
	
	--Search
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(4242574,0))
	e1:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetRange(LOCATION_HAND)
	e1:SetCost(c4242574.cost1)
	e1:SetTarget(c4242574.target1)
	e1:SetOperation(c4242574.operation1)
	c:RegisterEffect(e1)
	
	--Banish
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(4242574,1))
	e2:SetCountLimit(1,42425741)
	e2:SetCategory(CATEGORY_REMOVE)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e2:SetCode(EVENT_SUMMON_SUCCESS)
	e2:SetProperty(EFFECT_FLAG_CARD_TARGET+EFFECT_FLAG_DAMAGE_STEP)
	e2:SetCost(c4242574.sccost)
	e2:SetTarget(c4242574.target2)
	e2:SetOperation(c4242574.operation2)
	c:RegisterEffect(e2)
	local e3=e2:Clone()
	e3:SetCode(EVENT_SPSUMMON_SUCCESS)
	c:RegisterEffect(e3)
	
	--shuffle one 0x666 into the deck, select one spell or trap and send it back to the owner's deck
	--return a card to deck
	local e4=Effect.CreateEffect(c)
	e4:SetDescription(aux.Stringid(4242574,3))
	e4:SetCategory(CATEGORY_DESTROY)
	e4:SetType(EFFECT_TYPE_IGNITION)
	e4:SetRange(LOCATION_PZONE)
	e4:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e4:SetCountLimit(1,4242574)
	e4:SetCondition(c4242574.condition)
	e4:SetCost(c4242574.cost4)
	e4:SetTarget(c4242574.target4)
	e4:SetOperation(c4242574.operation4)
	c:RegisterEffect(e4)
end



--Effect 1 (Search) Code
function c4242574.cost1(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return c:IsAbleToGraveAsCost() and c:IsDiscardable() end
	Duel.SendtoGrave(c,REASON_COST+REASON_DISCARD)
end
function c4242574.filter1(c)
	return c:IsCode(4242564) and c:IsAbleToHand()
end
function c4242574.target1(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chk==0 then return Duel.IsExistingMatchingCard(c4242574.filter1,tp,0x51,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,0x51)
end
function c4242574.operation1(e,tp,eg,ep,ev,re,r,rp,chk)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local tg=Duel.SelectMatchingCard(tp,c4242574.filter1,tp,0x51,0,1,1,nil):GetFirst()
	if tg then
		Duel.SendtoHand(tg,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,tg)
	end
end



--Effect 2/3 (Banish code fuction
function c4242574.sccost(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return e:GetHandler() end
    Duel.Remove(e:GetHandler(),POS_FACEUP,nil)
end
function c4242574.target2(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_MZONE) and chkc:IsAbleToRemove() end
	if chk==0 then return Duel.IsExistingTarget(Card.IsAbleToRemove,tp,LOCATION_MZONE,LOCATION_MZONE,1,c,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
	local g=Duel.SelectTarget(tp,Card.IsAbleToRemove,tp,LOCATION_MZONE,LOCATION_MZONE,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_REMOVE,g,1,0,0)
end
function c4242574.operation2(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) then
		Duel.Remove(tc,POS_FACEUP,REASON_EFFECT)
	end
end

--Effect 4 anti back row
function c4242574.cfilter(c)
	return c:IsFaceup() and c:IsSetCard(0x666)
end
function c4242574.filter2(c)
	return c:IsFaceup() and c:IsType(TYPE_PENDULUM) and c:IsAbleToDeck() and c:IsSetCard(0x666) 
end
function c4242574.condition(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetMatchingGroup(c4242574.cfilter,tp,LOCATION_MZONE,0,nil)
	return g:GetClassCount(Card.GetCode)>=2
end
function c4242574.cost4(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return Duel.IsExistingMatchingCard(c4242574.filter2,tp,LOCATION_EXTRA,0,1,nil) end
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TODECK)
    local g=Duel.SelectMatchingCard(tp,c4242574.filter2,tp,LOCATION_EXTRA,0,1,1,nil)
    Duel.SendtoDeck(g,nil,2,REASON_COST)
end
function c4242574.filter3(c)
	return c:IsType(TYPE_SPELL+TYPE_TRAP) and c:IsAbleToDeck()
end
function c4242574.target4(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsOnField() and c4242574.filter3(chkc) and chkc~=e:GetHandler() end
	if chk==0 then return Duel.IsExistingTarget(c4242574.filter3,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,e:GetHandler()) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TODECK)
	local g=Duel.SelectTarget(tp,c4242574.filter3,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,1,e:GetHandler())
	Duel.SetOperationInfo(0,CATEGORY_TODECK,g,1,0,0)
end
function c4242574.operation4(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) then
		Duel.SendtoDeck(tc,nil,2,REASON_EFFECT)
		
	end
end