--Gathering of Phantasm
function c43811010.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCondition(c43811010.grcon)
	c:RegisterEffect(e1)
	--Recover
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e2:SetCategory(CATEGORY_RECOVER)
	e2:SetProperty(EFFECT_FLAG_DAMAGE_STEP)
	e2:SetCode(EVENT_TO_GRAVE)
	e2:SetRange(LOCATION_SZONE)
	e2:SetCondition(c43811010.lpcon)
	e2:SetOperation(c43811010.lpop)
	c:RegisterEffect(e2)
	--To Hand
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(43811010,0))
	e3:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_F)
	e3:SetCategory(CATEGORY_TOHAND)
	e3:SetProperty(EFFECT_FLAG_CARD_TARGET+EFFECT_FLAG_DELAY)
	e3:SetCode(EVENT_TO_GRAVE)
	e3:SetTarget(c43811010.thtg)
	e3:SetOperation(c43811010.thop)
	c:RegisterEffect(e3)
end
function c43811010.grcon(e)
	return Duel.IsExistingMatchingCard(Card.IsSetCard,e:GetHandlerPlayer(),LOCATION_GRAVE,0,1,nil,0x90e)
end
function c43811010.cfilter(c,tp)
	return c:IsSetCard(0x90e) and c:GetPreviousControler()==tp 
end
function c43811010.lpcon(e,tp,eg,ev,ep,re,r,rp)
	return eg:IsExists(c43811010.cfilter,1,nil,tp)
end
function c43811010.lpop(e,tp,eg,ev,ep,re,r,rp)
	local g=eg:Filter(c43811010.cfilter,nil,tp)
	Duel.Recover(tp,g:GetCount()*500,REASON_EFFECT)
end
function c43811010.dfilter(c)
	return c:IsSetCard(0x090e) and c:IsAbleToHand() and not c:IsCode(43811010)
end
function c43811010.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingTarget(c43811010.dfilter,tp,LOCATION_GRAVE,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectTarget(tp,c43811010.dfilter,tp,LOCATION_GRAVE,0,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,g,g:GetCount(),0,0)
end
function c43811010.thop(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetChainInfo(0,CHAININFO_TARGET_CARDS)
	local dg=g:Filter(Card.IsRelateToEffect,nil,e)
	if dg:GetCount()>0 then
		Duel.SendtoHand(dg,nil,REASON_EFFECT)
	end
end