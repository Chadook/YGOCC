--Lunar Phase Beast: Moon Burst the Wind Rider
function c4242566.initial_effect(c)
	--pendulum summon
	aux.EnablePendulumAttribute(c)
	
		--Search
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(4242566,0))
	e1:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetRange(LOCATION_HAND)
	e1:SetCost(c4242566.descon1)
	e1:SetTarget(c4242566.destg1)
	e1:SetOperation(c4242566.desop1)
	c:RegisterEffect(e1)
	--Pierce
local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetCode(EFFECT_PIERCE)
	e2:SetRange(LOCATION_PZONE)
	e2:SetTargetRange(LOCATION_ONFIELD,0)
	e2:SetTarget(c4242566.target)
	c:RegisterEffect(e2)
	--If deal damage,kill a thing
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(4242566,2))
	e3:SetCountLimit(1,42425661)
	e3:SetCategory(CATEGORY_DESTROY)
	e3:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e3:SetCode(EVENT_BATTLE_DAMAGE)
	e3:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e3:SetCondition(c4242566.descon)
	e3:SetTarget(c4242566.destg)
	e3:SetOperation(c4242566.desop)
	c:RegisterEffect(e3)
--Kill card draw
	local e4=Effect.CreateEffect(c)
	e4:SetDescription(aux.Stringid(4242566,3))
	e4:SetCountLimit(1,42425662)
	e4:SetCategory(CATEGORY_DRAW)
	e4:SetType(EFFECT_TYPE_IGNITION)
	e4:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e4:SetCode(EVENT_FREE_CHAIN)
	e4:SetRange(LOCATION_PZONE)
	e4:SetCost(c4242566.cost4)
	e4:SetTarget(c4242566.target4)
	e4:SetOperation(c4242566.operation4)
	c:RegisterEffect(e4)
end
function c4242566.filter4(c)
	return c:IsFaceup() and c:IsSetCard(0x666) and c:IsType(TYPE_SPELL+TYPE_TRAP) and not c:IsCode(4242566)
end
function c4242566.cost4(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingTarget(c4242566.filter4,tp,LOCATION_ONFIELD,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
	local g=Duel.SelectTarget(tp,c4242566.filter4,tp,LOCATION_ONFIELD,0,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,g,1,0,0)
	Duel.Destroy(g,REASON_EFFECT)
end
function c4242566.target4(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsPlayerCanDraw(tp,2) end
	Duel.SetTargetPlayer(tp)
	Duel.SetTargetParam(1)
	Duel.SetOperationInfo(0,CATEGORY_DRAW,nil,0,tp,2)
end
function c4242566.operation4(e,tp,eg,ep,ev,re,r,rp)
        if not e:GetHandler():IsRelateToEffect(e) then return end
    local p,d=Duel.GetChainInfo(0,CHAININFO_TARGET_PLAYER,CHAININFO_TARGET_PARAM)
    Duel.Draw(p,d,REASON_EFFECT)
end


--If deal damage,kill a thing
function c4242566.descon(e,tp,eg,ep,ev,re,r,rp)
	return ep~=tp
end
function c4242566.destg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsOnField() end
	if chk==0 then return Duel.IsExistingTarget(aux.TRUE,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
	local g=Duel.SelectTarget(tp,aux.TRUE,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,g,1,0,0)
end
function c4242566.desop(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) then
		Duel.Destroy(tc,REASON_EFFECT)
	end
end

--Effect 1 (Search) Code
function c4242566.descon1(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return c:IsAbleToGraveAsCost() and c:IsDiscardable() end
	Duel.SendtoGrave(c,REASON_COST+REASON_DISCARD)
end
function c4242566.filter(c)
	return c:IsCode(4242564) and c:IsAbleToHand()
end
function c4242566.destg1(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chk==0 then return Duel.IsExistingMatchingCard(c4242566.filter,tp,0x51,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,0x51)
end
function c4242566.desop1(e,tp,eg,ep,ev,re,r,rp,chk)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local tg=Duel.SelectMatchingCard(tp,c4242566.filter,tp,0x51,0,1,1,nil):GetFirst()
	if tg then
		Duel.SendtoHand(tg,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,tg)
	end
end
--Pierce
function c4242566.target(e,c)
	return c:IsSetCard(0x666) 
end