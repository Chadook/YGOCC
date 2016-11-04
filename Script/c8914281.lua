--Garbage Recycling Zone
function c8914281.initial_effect(c)
	c:EnableCounterPermit(0x716)
	c:SetCounterLimit(0x716,10)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	c:RegisterEffect(e1)
	--counter
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e2:SetCode(EVENT_TO_GRAVE)
	e2:SetRange(LOCATION_FZONE)
	e2:SetOperation(c8914281.counter)
	c:RegisterEffect(e2)
	--atk/def
	local e3=Effect.CreateEffect(c)
	e3:SetCategory(CATEGORY_ATKCHANGE)
	e3:SetType(EFFECT_TYPE_FIELD)
	e3:SetCode(EFFECT_UPDATE_ATTACK)
	e3:SetRange(LOCATION_FZONE)
	e3:SetTargetRange(LOCATION_MZONE,0)
	e3:SetTarget(aux.TargetBoolFunction(Card.IsSetCard,0x71a))
	e3:SetValue(c8914281.val)
	c:RegisterEffect(e3)
	local e4=e3:Clone()
	e4:SetCode(EFFECT_UPDATE_DEFENSE)
	c:RegisterEffect(e4)
	--to Grave
	local e5=Effect.CreateEffect(c)
	e5:SetCategory(CATEGORY_TOGRAVE)
	e5:SetType(EFFECT_TYPE_IGNITION)
	e5:SetRange(LOCATION_FZONE)
	e5:SetCountLimit(1)
	e5:SetCost(c8914281.thcost2)
	e5:SetTarget(c8914281.thtg2)
	e5:SetOperation(c8914281.thop2)
	c:RegisterEffect(e5)
	--to hand
	local e6=Effect.CreateEffect(c)
	e6:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
	e5:SetDescription(aux.Stringid(8914281,0))
	e6:SetType(EFFECT_TYPE_IGNITION)
	e6:SetRange(LOCATION_FZONE)
	e6:SetCountLimit(1)
	e6:SetCost(c8914281.thcost)
	e6:SetTarget(c8914281.thtg)
	e6:SetOperation(c8914281.thop)
	c:RegisterEffect(e6)
end
function c8914281.cfilter(c)
	return c:IsPreviousLocation(LOCATION_ONFIELD+LOCATION_HAND) and c:IsSetCard(0x71a) and c:IsType(TYPE_MONSTER)
end
function c8914281.counter(e,tp,eg,ep,ev,re,r,rp)
	local ct=eg:FilterCount(c8914281.cfilter,nil)
	if ct>0 then
		e:GetHandler():AddCounter(0x716,ct,true)
	end
end
function c8914281.acop(e,tp,eg,ep,ev,re,r,rp)
	local ct=eg:FilterCount(c8914281.cfilter,nil)
	if ct>0 then
		e:GetHandler():AddCounter(0x716,ct,true)
	end
end
function c8914281.val(e,c)
	return e:GetHandler():GetCounter(0x716)*100
end
function c8914281.thcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsCanRemoveCounter(tp,0x716,5,REASON_COST) end
	e:GetHandler():RemoveCounter(tp,0x716,5,REASON_COST)
end
function c8914281.thfilter(c)
	return c:IsType(TYPE_MONSTER) and c:IsSetCard(0x71a) or (c:IsCode(18698739) or c:IsCode(44682448)) and c:IsAbleToHand()
end
function c8914281.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c8914281.thfilter,tp,LOCATION_DECK,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
end
function c8914281.thop(e,tp,eg,ep,ev,re,r,rp)
	if not e:GetHandler():IsRelateToEffect(e) then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,c8914281.thfilter,tp,LOCATION_DECK,0,1,1,nil)
	if g:GetCount()>0 then
		Duel.SendtoHand(g,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,g)
	end
end
function c8914281.thcost2(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsCanRemoveCounter(tp,0x716,1,REASON_COST) end
	e:GetHandler():RemoveCounter(tp,0x716,1,REASON_COST)
end
function c8914281.thfilter2(c)
	return c:IsSetCard(0x71a) or (c:IsCode(18698739) or c:IsCode(44682448)) and c:IsAbleToGrave()
end
function c8914281.thtg2(e,tp,eg,ep,ev,re,r,rp,chk)
if chk==0 then return Duel.IsExistingMatchingCard(c8914281.thfilter2,tp,LOCATION_DECK,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOGRAVE,nil,1,tp,LOCATION_DECK)
end
function c8914281.thop2(e,tp,eg,ep,ev,re,r,rp)
if not e:GetHandler():IsRelateToEffect(e) then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
	local g=Duel.SelectMatchingCard(tp,c8914281.thfilter2,tp,LOCATION_DECK,0,1,1,nil)
	if g:GetCount()>0 then
		Duel.SendtoGrave(g,REASON_EFFECT)
	end
end	